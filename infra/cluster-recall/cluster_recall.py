#!/usr/bin/env python3
import json
import os
import re
import sys
import uuid
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib import error, request


BASE_DIR = "/opt/cluster-recall"
PORT = 8635
EMBED_MODEL = "text-embedding-3-small"
SEARCH_COLLECTIONS = ("knowledge", "agent_lessons")
MAX_TEXT_LEN = 300


def load_env_file(path):
    values = {}
    if not os.path.exists(path):
        return values
    with open(path, "r", encoding="utf-8") as fh:
        for raw in fh:
            line = raw.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            if line.startswith("export "):
                line = line[7:].strip()
            match = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$", line)
            if not match:
                continue
            name, value = match.group(1), match.group(2).strip()
            if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
                value = value[1:-1]
            values[name] = value
    return values


def load_config():
    merged = {}
    merged.update(load_env_file("/opt/cluster-portal/bin/embed-sync.env"))
    merged.update(load_env_file(os.path.join(BASE_DIR, ".env")))
    merged.update(os.environ)
    required = ("LITELLM_KEY", "EMBED_URL", "QDRANT_URL", "QDRANT_API_KEY", "RECALL_TOKEN")
    missing = [name for name in required if not merged.get(name)]
    if missing:
        raise RuntimeError("missing required env vars: " + ", ".join(missing))
    return merged


CONFIG = load_config()


def http_json(method, url, payload=None, headers=None, timeout=30):
    body = None
    out_headers = dict(headers or {})
    if payload is not None:
        body = json.dumps(payload).encode("utf-8")
        out_headers["Content-Type"] = "application/json"
    req = request.Request(url, data=body, headers=out_headers, method=method)
    try:
        with request.urlopen(req, timeout=timeout) as resp:
            raw = resp.read().decode("utf-8", "replace")
            data = json.loads(raw) if raw else None
            return resp.status, data
    except error.HTTPError as exc:
        raw = exc.read().decode("utf-8", "replace")
        try:
            data = json.loads(raw) if raw else None
        except json.JSONDecodeError:
            data = {"error": raw[:500]}
        return exc.code, data


def embed_text(text):
    code, data = http_json(
        "POST",
        CONFIG["EMBED_URL"].rstrip("/"),
        {"model": EMBED_MODEL, "input": text},
        {"Authorization": "Bearer " + CONFIG["LITELLM_KEY"]},
    )
    if code != 200:
        raise RuntimeError(f"embedding request failed: http {code}")
    return data["data"][0]["embedding"]


def qdrant_headers():
    return {"api-key": CONFIG["QDRANT_API_KEY"]}


def qdrant_url(path):
    return CONFIG["QDRANT_URL"].rstrip("/") + path


def payload_text(payload):
    for key in ("text", "content", "chunk", "body", "page_content"):
        value = payload.get(key)
        if isinstance(value, str) and value:
            return value[:MAX_TEXT_LEN]
    return ""


def payload_source(payload):
    for key in ("source", "file", "path", "url", "title"):
        value = payload.get(key)
        if isinstance(value, str) and value:
            return value
    return None


def search_collection(collection, vector, limit):
    code, data = http_json(
        "POST",
        qdrant_url(f"/collections/{collection}/points/search"),
        {"vector": vector, "limit": limit, "with_payload": True},
        qdrant_headers(),
    )
    if code != 200:
        return []
    points = data.get("result") or []
    hits = []
    for point in points:
        payload = point.get("payload") or {}
        hits.append(
            {
                "score": point.get("score"),
                "collection": collection,
                "source": payload_source(payload),
                "text": payload_text(payload),
            }
        )
    return hits


def recall(query, k):
    vector = embed_text(query)
    merged = []
    for collection in SEARCH_COLLECTIONS:
        merged.extend(search_collection(collection, vector, k))
    merged.sort(key=lambda item: item.get("score") or 0, reverse=True)
    return merged[:k]


def upsert_lesson(text, agent, source=None, tags=None):
    vector = embed_text(text)
    point_id = str(uuid.uuid4())
    payload = {
        "agent": agent,
        "ts": datetime.now(timezone.utc).isoformat(),
        "text": text,
        "source": source,
        "tags": tags or [],
    }
    code, data = http_json(
        "PUT",
        qdrant_url("/collections/agent_lessons/points"),
        {"points": [{"id": point_id, "vector": vector, "payload": payload}]},
        qdrant_headers(),
    )
    if code not in (200, 201):
        raise RuntimeError(f"lesson upsert failed: http {code}")
    return point_id


class Handler(BaseHTTPRequestHandler):
    server_version = "cluster-recall/1.0"

    def log_message(self, fmt, *args):
        sys.stderr.write("%s - - [%s] %s\n" % (self.address_string(), self.log_date_time_string(), fmt % args))

    def send_json(self, code, payload):
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def read_json(self):
        length = int(self.headers.get("Content-Length") or "0")
        if length <= 0:
            return {}
        raw = self.rfile.read(length).decode("utf-8")
        return json.loads(raw)

    def authorized(self):
        header = self.headers.get("Authorization", "")
        return header == "Bearer " + CONFIG["RECALL_TOKEN"]

    def do_GET(self):
        if self.path == "/health":
            self.send_json(200, {"ok": True})
            return
        self.send_json(404, {"error": "not_found"})

    def do_POST(self):
        if self.path not in ("/recall", "/lesson"):
            self.send_json(404, {"error": "not_found"})
            return
        if not self.authorized():
            self.send_json(401, {"error": "unauthorized"})
            return
        try:
            body = self.read_json()
            if self.path == "/recall":
                query = body.get("query")
                k = int(body.get("k", 5))
                if not isinstance(query, str) or not query.strip():
                    self.send_json(400, {"error": "query_required"})
                    return
                if k < 1:
                    k = 1
                if k > 20:
                    k = 20
                self.send_json(200, {"results": recall(query, k)})
                return
            text = body.get("text")
            agent = body.get("agent")
            if not isinstance(text, str) or not text.strip():
                self.send_json(400, {"error": "text_required"})
                return
            if not isinstance(agent, str) or not agent.strip():
                self.send_json(400, {"error": "agent_required"})
                return
            tags = body.get("tags") or []
            if not isinstance(tags, list):
                self.send_json(400, {"error": "tags_must_be_list"})
                return
            point_id = upsert_lesson(text, agent, body.get("source"), tags)
            self.send_json(200, {"ok": True, "id": point_id})
        except json.JSONDecodeError:
            self.send_json(400, {"error": "invalid_json"})
        except Exception as exc:
            self.send_json(500, {"error": str(exc)})


def main():
    server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
    server.serve_forever()


if __name__ == "__main__":
    main()
