#!/bin/bash
# cluster-update #10 rollout: push provision-unattended.sh into every PVE host + every running
# LXC, timeout-bounded. Mirrors collector.sh discovery. Tor LXC 108 has no egress -> its apt
# hangs -> bounded by `timeout` and reported as PROV_TIMEOUT, loop continues. QEMU VMs (OpenClaw
# 100, OPNsense 102/104) are NOT reached by this pipe and stay fully manual by construction.
SK="/root/.ssh/id_scan"
P="/opt/cluster-update/provision-unattended.sh"
NODES="192.168.1.15 192.168.1.16"
O="-i $SK -o BatchMode=yes -o ConnectTimeout=8 -o StrictHostKeyChecking=accept-new"
for n in $NODES; do
  echo "== HOST $n =="
  timeout 220 ssh $O root@$n "bash -s" < "$P" || echo "PROV_TIMEOUT host=$n"
  for id in $(ssh $O root@$n "pct list" 2>/dev/null | awk 'NR>1 && $2=="running"{print $1}'); do
    timeout 120 ssh $O root@$n "pct exec $id -- bash -s" < "$P" || echo "PROV_TIMEOUT lxc=$id@$n"
  done
done
echo "ROLLOUT_DONE"
