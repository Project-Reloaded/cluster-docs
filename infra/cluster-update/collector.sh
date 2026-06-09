#!/bin/bash
# cluster-update collector (read-only). Discovers running LXCs on each node,
# pipes agent.sh via stdin into each host/LXC. Emits one JSON line per host,
# then "COLLECTOR_DONE".
#
# 2026-06-07 FIX: per-host agent run is now wrapped in `timeout`. Previously a
# host whose `apt-get update` blocks forever (Tor LXC 108 has no normal egress)
# hung the whole loop, so COLLECTOR_DONE was never reached and the run could not
# be cron'd. On timeout we emit a fallback {"error":"timeout"} line and continue,
# so the collector always terminates and every host yields exactly one line.
SK="/root/.ssh/id_scan"
AGENT="/opt/cluster-update/agent.sh"
NODES="192.168.1.15 192.168.1.16"
SSHO="-i $SK -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=accept-new"
HOSTTMO="${HOSTTMO:-45}"   # seconds per host before we give up and move on

for n in $NODES; do
  # the Proxmox host itself
  timeout "$HOSTTMO" ssh $SSHO root@$n "bash -s" < "$AGENT" 2>/dev/null \
    || echo "{\"host\":\"node@$n\",\"error\":\"timeout\"}"
  # running LXCs on this node (parsed locally to avoid nested quoting)
  LXCS=$(ssh $SSHO root@$n "pct list" 2>/dev/null | awk 'NR>1 && $2=="running"{print $1}')
  for id in $LXCS; do
    timeout "$HOSTTMO" ssh $SSHO root@$n "pct exec $id -- bash -s" < "$AGENT" 2>/dev/null \
      || echo "{\"host\":\"lxc$id@$n\",\"error\":\"timeout\"}"
  done
done
echo "COLLECTOR_DONE"
