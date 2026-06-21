#!/usr/bin/env bash
set -euo pipefail

SSH_OPTS=(-i /root/.ssh/id_openclaw -o BatchMode=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8)
NODE1=root@192.168.1.15
VM112=root@10.6.7.22

tmp_token="$(mktemp)"
cleanup() {
  rm -f "$tmp_token"
  ssh "${SSH_OPTS[@]}" "$NODE1" 'rm -f /tmp/cluster-recall-token.tmp' >/dev/null 2>&1 || true
}
trap cleanup EXIT

ssh "${SSH_OPTS[@]}" "$VM112" "awk -F= '\$1==\"RECALL_TOKEN\"{print \$2}' /opt/cluster-recall/.env" > "$tmp_token"
test -s "$tmp_token"
chmod 600 "$tmp_token"

scp "${SSH_OPTS[@]}" /root/.openclaw/workspace/cluster-recall-build/cluster_recall_wrapper.sh "$NODE1":/tmp/cluster_recall_wrapper.sh >/dev/null
scp "${SSH_OPTS[@]}" /root/.openclaw/workspace/cluster-recall-build/cluster-recall-SKILL.md "$NODE1":/tmp/cluster-recall-SKILL.md >/dev/null
scp "${SSH_OPTS[@]}" "$tmp_token" "$NODE1":/tmp/cluster-recall-token.tmp >/dev/null

ssh "${SSH_OPTS[@]}" "$NODE1" 'bash -s' <<'REMOTE'
set -euo pipefail
stage="init"
fail(){ echo "{"error":"stage=$stage line=$1"}"; exit 1; }
trap 'fail $LINENO' ERR

stage="health"
health_code="$(pct exec 101 -- curl -s -m5 -o /dev/null -w '%{http_code}' http://10.6.7.22:8635/health)"

stage="token"
token="$(cat /tmp/cluster-recall-token.tmp)"
test -n "$token"

stage="dirs"
pct exec 101 -- mkdir -p /root/.hermes/skills/cluster-recall

stage="env"
printf 'RECALL_URL=http://10.6.7.22:8635\nRECALL_TOKEN=%s\n' "$token" | pct exec 101 -- sh -c 'umask 077; cat > /root/.hermes/.env; chmod 600 /root/.hermes/.env'
token_mode="$(pct exec 101 -- sh -c 'test -s /root/.hermes/.env && grep -q "^RECALL_URL=http://10.6.7.22:8635$" /root/.hermes/.env && grep -q "^RECALL_TOKEN=." /root/.hermes/.env && stat -c %a /root/.hermes/.env')"

stage="push_files"
pct push 101 /tmp/cluster_recall_wrapper.sh /usr/local/bin/cluster_recall -perms 0755
pct exec 101 -- ln -sf /usr/local/bin/cluster_recall /usr/bin/cluster_recall
pct push 101 /tmp/cluster-recall-SKILL.md /root/.hermes/skills/cluster-recall/SKILL.md -perms 0644

stage="soul"
pct exec 101 -- sh -c 'touch /root/.hermes/SOUL.md; grep -Fqx "Local-first: vor jeder Recherche zuerst cluster_recall nutzen (gemeinsames Gedaechtnis)." /root/.hermes/SOUL.md || printf "\nLocal-first: vor jeder Recherche zuerst cluster_recall nutzen (gemeinsames Gedaechtnis).\n" >> /root/.hermes/SOUL.md'

stage="hermes_symlink"
pct exec 101 -- sh -c 'if [ -x /usr/local/bin/hermes ]; then ln -sf /usr/local/bin/hermes /usr/bin/hermes; fi'

stage="verify_wrapper"
wrapper_out="$(pct exec 101 -- cluster_recall 'OPNsense hairpin NAT fix')"
top1="$(printf '%s' "$wrapper_out" | python3 -c 'import json,sys; data=json.load(sys.stdin); r=(data.get("results") or [{}])[0]; print(json.dumps({"score":r.get("score"),"source":r.get("source"),"collection":r.get("collection")}, sort_keys=True))')"

stage="verify_skill"
if pct exec 101 -- sh -c 'hermes skills list 2>&1 | grep -i cluster-recall >/dev/null'; then skill_listed="yes"; else skill_listed="no"; fi

stage="verify_soul"
if pct exec 101 -- tail -2 /root/.hermes/SOUL.md | grep -F "Local-first: vor jeder Recherche zuerst cluster_recall nutzen (gemeinsames Gedaechtnis)." >/dev/null; then soul_line="yes"; else soul_line="no"; fi

stage="emit"
HEALTH_CODE="$health_code" TOKEN_MODE="$token_mode" SKILL_LISTED="$skill_listed" SOUL_LINE="$soul_line" TOP1="$top1" python3 - <<'PY'
import json, os
print(json.dumps({
  "health_code": os.environ["HEALTH_CODE"],
  "token_set": "yes" if os.environ["TOKEN_MODE"] == "600" else "no",
  "wrapper_top1": json.loads(os.environ["TOP1"]),
  "skill_listed": os.environ["SKILL_LISTED"],
  "soul_line": os.environ["SOUL_LINE"],
}, ensure_ascii=False, sort_keys=True))
PY
REMOTE
