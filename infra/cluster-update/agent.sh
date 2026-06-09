#!/bin/bash
# cluster-update read-only status reporter. Prints ONE JSON line. Applies NOTHING.
host=$(hostname 2>/dev/null)
apt-get update -qq >/dev/null 2>&1
upg=$(apt-get -s upgrade 2>/dev/null | grep -c '^Inst ')
reboot=false; [ -f /var/run/reboot-required ] && reboot=true
docker=""
if command -v docker >/dev/null 2>&1; then
  docker=$(docker ps --format '{{.Names}}={{.Image}}' 2>/dev/null | paste -sd';' -)
fi
kern=$(uname -r 2>/dev/null)
printf '{"host":"%s","kernel":"%s","upgradable":%s,"reboot_required":%s,"docker":"%s"}\n' "$host" "$kern" "${upg:-0}" "$reboot" "$docker"
