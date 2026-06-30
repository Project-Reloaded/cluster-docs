#!/usr/bin/env bash
# cluster-guardian — L0 lokaler Floor (Welle 1)
# Ein dummer, schlüsselloser Watchdog: prüft den LOKALEN Agenten funktional und
# startet ihn bei anhaltender Unresponsivität neu. Kein Cluster-Key, kein Peer-Zugriff.
# Konfiguration kommt aus /etc/cluster-guardian.env (siehe DEPLOY_WELLE1.md).
#
# MODE=report  -> erkennt + loggt, startet NICHT neu (Beobachtungsphase)
# MODE=arm     -> startet bei Bedarf neu (rate-limitiert)
set -euo pipefail

ENVFILE=/etc/cluster-guardian.env
[ -r "$ENVFILE" ] && . "$ENVFILE"

: "${AGENT_NAME:=unknown}"
: "${MODE:=report}"
: "${HEALTH_MODE:=http}"
: "${PROBE_TIMEOUT:=8}"
: "${FAIL_THRESHOLD:=3}"
: "${MAX_RESTARTS:=3}"
: "${WINDOW_SEC:=1800}"
: "${STATE_DIR:=/var/lib/cluster-guardian}"
LOG=/var/log/cluster-guardian.log

mkdir -p "$STATE_DIR"
log(){ echo "[$(date -u +%FT%TZ)] $*" >> "$LOG"; }

healthy() {
  case "$HEALTH_MODE" in
    http)
      # gesund = HTTP antwortet rechtzeitig UND Body enthält HEALTH_EXPECT
      local body
      body=$(curl -s -m "$PROBE_TIMEOUT" "$HEALTH_URL" 2>/dev/null) || return 1
      [ -n "${HEALTH_EXPECT:-}" ] && { echo "$body" | grep -q "$HEALTH_EXPECT" || return 1; }
      ;;
    proc)
      # gesund = Prozess existiert; optionaler HTTP-Subcheck (z.B. Studio-Liveness)
      pgrep -f "$PROC_PATTERN" >/dev/null 2>&1 || return 1
      if [ -n "${SUBCHECK_URL:-}" ]; then
        curl -s -m "$PROBE_TIMEOUT" -o /dev/null "$SUBCHECK_URL" 2>/dev/null || return 1
      fi
      ;;
    *) log "FEHLER unbekannter HEALTH_MODE=$HEALTH_MODE"; return 0 ;;
  esac
  return 0
}

FAILFILE="$STATE_DIR/consec_fail"
HIST="$STATE_DIR/restarts"
touch "$HIST"   # Restart-History sicherstellen: awk auf fehlende Datei crasht sonst unter set -euo pipefail
fails=$(cat "$FAILFILE" 2>/dev/null || echo 0)

if healthy; then
  echo 0 > "$FAILFILE"
  # Heartbeat NUR wenn gesund -> Kuma wird rot, sobald der Agent krank ist
  [ -n "${HEARTBEAT_URL:-}" ] && curl -s -m5 "$HEARTBEAT_URL" >/dev/null 2>&1 || true
  exit 0
fi

fails=$((fails+1)); echo "$fails" > "$FAILFILE"
log "UNHEALTHY agent=$AGENT_NAME consec=$fails/$FAIL_THRESHOLD"
[ "$fails" -lt "$FAIL_THRESHOLD" ] && exit 0

# Schwelle erreicht -> Restart erwägen, aber rate-limitiert
now=$(date +%s)
recent=$(awk -v n="$now" -v w="$WINDOW_SEC" '$1 > n-w' "$HIST" 2>/dev/null | wc -l)
if [ "$recent" -ge "$MAX_RESTARTS" ]; then
  log "RATE-LIMIT agent=$AGENT_NAME ($recent Restarts in ${WINDOW_SEC}s >= $MAX_RESTARTS) -> NUR Alarm, kein Restart"
  exit 0
fi

if [ "$MODE" = "arm" ]; then
  log "RESTART agent=$AGENT_NAME service=$SERVICE (mode=arm)"
  echo "$now" >> "$HIST"
  systemctl restart "$SERVICE" 2>>"$LOG" || log "RESTART FEHLGESCHLAGEN service=$SERVICE"
  echo 0 > "$FAILFILE"
else
  log "WOULD-RESTART agent=$AGENT_NAME service=$SERVICE (mode=report, KEINE Aktion)"
fi
exit 0
