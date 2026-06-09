#!/bin/bash
# cluster-update #10 — provision unattended-upgrades (idempotent, run per host via stdin,
# same pipe pattern as agent.sh: `ssh host "pct exec ID -- bash -s" < provision-unattended.sh`).
#
# Tier is auto-detected:
#   * PVE host (/etc/pve exists)  -> SECURITY-ONLY. PVE-repo + kernel stay manual (Tier 3).
#   * Debian/Ubuntu LXC           -> FULL upgrade (Bau-Phase: main+updates+security+backports).
# NEVER enables automatic reboot — single-node without quorum, reboot is only *reported* by the
# 02:00 collector (agent.sh reboot_required). OpenClaw(vm-100) and the OPNsense VMs are QEMU VMs
# and are not reached by this pipe at all, so they stay fully manual by construction.
set -e
export DEBIAN_FRONTEND=noninteractive
H=$(hostname 2>/dev/null || echo "?")

# Only act on apt-based systems; silently no-op elsewhere.
command -v apt-get >/dev/null 2>&1 || { echo "SKIP host=$H (no apt)"; exit 0; }

if [ -d /etc/pve ]; then TIER=pve; else TIER=lxc; fi

# Ensure the package is present (quiet).
if ! command -v unattended-upgrade >/dev/null 2>&1; then
  apt-get -qq update >/dev/null 2>&1 || true
  apt-get -qq -y install unattended-upgrades >/dev/null 2>&1 || { echo "FAIL host=$H install"; exit 1; }
fi

CONF=/etc/apt/apt.conf.d/52cluster-unattended
if [ "$TIER" = pve ]; then
  # SECURITY ONLY — Debian/Ubuntu security pockets. Proxmox repo intentionally excluded.
  cat > "$CONF" <<'EOF'
// Managed by cluster-update #10 (tier: pve = security-only). Do not edit by hand.
Unattended-Upgrade::Origins-Pattern {
  "origin=Debian,codename=${distro_codename},label=Debian-Security";
  "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";
  "origin=Ubuntu,archive=${distro_codename}-security";
};
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Mail "";
EOF
else
  # FULL — Bau-Phase: main + updates + security + backports.
  cat > "$CONF" <<'EOF'
// Managed by cluster-update #10 (tier: lxc = full upgrade, Bau-Phase). Do not edit by hand.
Unattended-Upgrade::Origins-Pattern {
  "origin=Debian,codename=${distro_codename}";
  "origin=Debian,codename=${distro_codename}-updates";
  "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";
  "origin=Debian,codename=${distro_codename}-backports";
  "origin=Ubuntu,archive=${distro_codename}";
  "origin=Ubuntu,archive=${distro_codename}-updates";
  "origin=Ubuntu,archive=${distro_codename}-security";
};
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Mail "";
EOF
fi

# Drive the apt periodic timers (download + unattended-upgrade daily).
cat > /etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
EOF

systemctl enable --now apt-daily.timer apt-daily-upgrade.timer >/dev/null 2>&1 || true

# Validate config parses; report.
if unattended-upgrade --dry-run >/dev/null 2>&1; then DRY=ok; else DRY=WARN; fi
echo "PROVISIONED host=$H tier=$TIER dryrun=$DRY"
