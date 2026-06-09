#!/usr/bin/env python3
"""
cluster-update report renderer (#8).

Reads the collector's JSONL (one JSON object per host, terminated by a
"COLLECTOR_DONE" sentinel line) and renders a Markdown status table.

Agent JSON keys (thin/Sicht-zuerst variant, 2026-06-07):
    host, kernel, upgradable (int), reboot_required (bool), docker (bool)
A host that timed out emits: {"host": "...", "error": "timeout"}

Usage:
    render_report.py < state.jsonl              # print Markdown to stdout
    render_report.py --push < state.jsonl       # also push to Outline (needs env)

Push env (kept out of the repo; lives in /opt/cluster-update/report.env, 600):
    OUTLINE_API_URL   e.g. https://outline.project-reloaded.org
    OUTLINE_TOKEN     Outline API token (Bearer)
    OUTLINE_DOC_ID    id of the fixed "Cluster Update Status" document
"""
import json
import os
import sys
import urllib.request
from datetime import datetime, timezone


def classify(h):
    if h.get("error"):
        return "⚠️", f"nicht erreicht ({h['error']})"
    if h.get("reboot_required"):
        return "🔴", "Reboot nötig (manuell, Single-Node)"
    up = int(h.get("upgradable", 0) or 0)
    if up > 0:
        return "🟡", f"{up} Paket(e) offen"
    return "✅", "aktuell"


def render(hosts):
    now = datetime.now(timezone.utc).astimezone().strftime("%Y-%m-%d %H:%M %Z")
    n_ok = sum(1 for h in hosts if not h.get("error") and not h.get("reboot_required")
               and int(h.get("upgradable", 0) or 0) == 0)
    n_upd = sum(1 for h in hosts if not h.get("error") and int(h.get("upgradable", 0) or 0) > 0
                and not h.get("reboot_required"))
    n_reboot = sum(1 for h in hosts if h.get("reboot_required"))
    n_err = sum(1 for h in hosts if h.get("error"))

    lines = []
    lines.append("# Cluster Update Status")
    lines.append("")
    lines.append(f"_Automatisch erzeugt: {now} · {len(hosts)} Hosts · "
                 f"✅ {n_ok} aktuell · 🟡 {n_upd} Updates · 🔴 {n_reboot} Reboot · "
                 f"⚠️ {n_err} nicht erreicht_")
    lines.append("")
    lines.append("| Host | Status | Kernel | Pakete offen | Reboot | Docker | Hinweis |")
    lines.append("|---|---|---|---:|:---:|:---:|---|")
    for h in sorted(hosts, key=lambda x: str(x.get("host", ""))):
        icon, note = classify(h)
        host = str(h.get("host", "?"))
        kernel = str(h.get("kernel", "")) if not h.get("error") else ""
        up = "" if h.get("error") else str(int(h.get("upgradable", 0) or 0))
        reboot = "🔴" if h.get("reboot_required") else ("" if h.get("error") else "–")
        docker = "🐳" if h.get("docker") else ""
        lines.append(f"| {host} | {icon} | {kernel} | {up} | {reboot} | {docker} | {note} |")
    lines.append("")
    lines.append("> Legende: ✅ keine offenen Pakete · 🟡 Pakete verfügbar (Security via "
                 "unattended-upgrades) · 🔴 Reboot nötig, bleibt manuell solange Single-Node "
                 "ohne Quorum · ⚠️ Host im Lauf nicht erreichbar/Timeout.")
    return "\n".join(lines)


def parse(stream):
    hosts = []
    for raw in stream:
        raw = raw.strip()
        if not raw or raw == "COLLECTOR_DONE":
            continue
        try:
            hosts.append(json.loads(raw))
        except json.JSONDecodeError:
            hosts.append({"host": "?", "error": "bad-json"})
    return hosts


def push_outline(markdown):
    base = os.environ.get("OUTLINE_API_URL", "").rstrip("/")
    token = os.environ.get("OUTLINE_TOKEN", "")
    doc_id = os.environ.get("OUTLINE_DOC_ID", "")
    if not (base and token and doc_id):
        sys.stderr.write("push: OUTLINE_API_URL/OUTLINE_TOKEN/OUTLINE_DOC_ID incomplete — skipped\n")
        return False
    body = json.dumps({"id": doc_id, "text": markdown}).encode()
    req = urllib.request.Request(
        f"{base}/api/documents.update", data=body, method="POST",
        headers={"Content-Type": "application/json",
                 "Authorization": f"Bearer {token}"})
    with urllib.request.urlopen(req, timeout=20) as resp:
        ok = resp.status == 200
        sys.stderr.write(f"push: documents.update HTTP {resp.status}\n")
        return ok


def main():
    hosts = parse(sys.stdin)
    md = render(hosts)
    print(md)
    if "--push" in sys.argv[1:]:
        try:
            push_outline(md)
        except Exception as e:  # noqa: BLE001 — report-only, never fail the run
            sys.stderr.write(f"push: failed: {e}\n")


if __name__ == "__main__":
    main()
