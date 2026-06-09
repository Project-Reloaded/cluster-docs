#!/bin/bash
# cluster-update report wrapper (#8) — cron @ 02:00 on vm-112.
# Pattern matches embed-sync-run.sh: source env (set -a), then run; always
# push a Kuma heartbeat at the end so the monitor flips green even on a no-op.
set -uo pipefail
BASE="/opt/cluster-update"
ENVF="$BASE/report.env"
STATE="$BASE/state.jsonl"
LOG="/var/log/cluster-update/report.log"
mkdir -p "$(dirname "$LOG")"

[ -f "$ENVF" ] && { set -a; . "$ENVF"; set +a; }

{
  echo "=== $(date -Is) report run ==="
  # collect (atomic): only replace state on a clean COLLECTOR_DONE
  if bash "$BASE/collector.sh" > "$STATE.tmp" 2>>"$LOG" \
       && grep -q '^COLLECTOR_DONE$' "$STATE.tmp"; then
    mv "$STATE.tmp" "$STATE"
    echo "collector OK ($(grep -c '^{' "$STATE") host-lines)"
  else
    rm -f "$STATE.tmp"
    echo "collector FAILED — keeping previous state.jsonl"
  fi
  # render + push (push is a no-op if report.env lacks Outline creds)
  python3 "$BASE/render_report.py" --push < "$STATE" > "$BASE/last-report.md" 2>>"$LOG"
  echo "rendered $(wc -l < "$BASE/last-report.md") md-lines"
} >> "$LOG" 2>&1

# unconditional Kuma heartbeat (see feedback_embed_sync_unconditional_heartbeat)
[ -n "${HEARTBEAT_URL:-}" ] && curl -sf -m5 "$HEARTBEAT_URL" >/dev/null 2>&1 || true
