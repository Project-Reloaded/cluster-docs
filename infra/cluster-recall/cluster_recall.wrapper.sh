#!/bin/sh
set -eu
if [ "${RECALL_ENV_FILE:-}" != "" ]; then
  ENV_FILE="$RECALL_ENV_FILE"
elif [ -r /root/.cluster-recall.env ]; then
  ENV_FILE="/root/.cluster-recall.env"
elif [ -r /root/.hermes/.env ]; then
  ENV_FILE="/root/.hermes/.env"
else
  ENV_FILE="/root/.openclaw/cluster-recall.env"
fi
if [ ! -r "$ENV_FILE" ]; then
  echo '{"error":"missing recall env file"}' >&2
  exit 2
fi
set -a
. "$ENV_FILE"
set +a
if [ "${RECALL_URL:-}" = "" ] || [ "${RECALL_TOKEN:-}" = "" ]; then
  echo '{"error":"missing RECALL_URL or RECALL_TOKEN"}' >&2
  exit 2
fi
if [ "$#" -lt 1 ] || [ "$1" = "" ]; then
  echo "usage: cluster_recall <query>" >&2
  exit 2
fi
query="$1"
json_query=$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$query")
body=$(printf '{"query":%s,"k":5}' "$json_query")
curl -sS -m 30 -H "Authorization: Bearer ${RECALL_TOKEN}" -H "Content-Type: application/json" -d "$body" "${RECALL_URL%/}/recall"
