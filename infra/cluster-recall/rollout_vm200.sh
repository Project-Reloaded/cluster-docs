#!/usr/bin/env bash
set -euo pipefail

SSH_OPTS=(-i /root/.ssh/id_openclaw -o BatchMode=yes -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8)
NODE2=root@192.168.1.16
VM112=root@10.6.7.22

tmp_token="$(mktemp)"
cleanup() {
  rm -f "$tmp_token"
  ssh "${SSH_OPTS[@]}" "$NODE2" 'rm -f /tmp/cluster-recall-token.tmp /tmp/paperclip_cluster_recall_wrapper.sh' >/dev/null 2>&1 || true
}
trap cleanup EXIT

ssh "${SSH_OPTS[@]}" "$VM112" "awk -F= '\$1==\"RECALL_TOKEN\"{print \$2}' /opt/cluster-recall/.env" > "$tmp_token"
test -s "$tmp_token"
chmod 600 "$tmp_token"

scp "${SSH_OPTS[@]}" /root/.openclaw/workspace/cluster-recall-build/paperclip_cluster_recall_wrapper.sh "$NODE2":/tmp/paperclip_cluster_recall_wrapper.sh >/dev/null
scp "${SSH_OPTS[@]}" "$tmp_token" "$NODE2":/tmp/cluster-recall-token.tmp >/dev/null

ssh "${SSH_OPTS[@]}" "$NODE2" 'bash -s' <<'REMOTE'
set -euo pipefail
stage="init"
fail(){ echo "{\"error\":\"stage=$stage line=$1\"}"; exit 1; }
trap 'fail $LINENO' ERR

stage="health"
health_code="$(pct exec 200 -- curl -s -m5 -o /dev/null -w '%{http_code}' http://10.6.7.22:8635/health)"

stage="token"
token="$(cat /tmp/cluster-recall-token.tmp)"
test -n "$token"

stage="env"
printf 'RECALL_URL=http://10.6.7.22:8635\nRECALL_TOKEN=%s\n' "$token" | pct exec 200 -- sh -c 'umask 077; cat > /root/.cluster-recall.env; chmod 600 /root/.cluster-recall.env'
token_mode="$(pct exec 200 -- sh -c 'test -s /root/.cluster-recall.env && grep -q "^RECALL_URL=http://10.6.7.22:8635$" /root/.cluster-recall.env && grep -q "^RECALL_TOKEN=." /root/.cluster-recall.env && stat -c %a /root/.cluster-recall.env')"

stage="wrapper"
pct push 200 /tmp/paperclip_cluster_recall_wrapper.sh /usr/local/bin/cluster_recall -perms 0755
pct exec 200 -- ln -sf /usr/local/bin/cluster_recall /usr/bin/cluster_recall

stage="verify_wrapper"
wrapper_out="$(pct exec 200 -- cluster_recall 'OPNsense hairpin NAT fix')"
top1="$(printf '%s' "$wrapper_out" | python3 -c 'import json,sys; data=json.load(sys.stdin); r=(data.get("results") or [{}])[0]; print(json.dumps({"score":r.get("score"),"source":r.get("source"),"collection":r.get("collection")}, sort_keys=True))')"

stage="emit"
HEALTH_CODE="$health_code" TOKEN_MODE="$token_mode" TOP1="$top1" python3 - <<'PY'
import json, os
print(json.dumps({
  "health_code": os.environ["HEALTH_CODE"],
  "token_set": "yes" if os.environ["TOKEN_MODE"] == "600" else "no",
  "wrapper_top1": json.loads(os.environ["TOP1"]),
}, ensure_ascii=False, sort_keys=True))
PY
REMOTE
