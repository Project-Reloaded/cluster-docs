# Cluster Recall

Shared local-first recall service for cluster agents.

## Zweck

cluster-recall exposes a small HTTP API on vm-112 so agents can search the shared
cluster memory before using external search or model-only recall. It embeds queries
through the existing LiteLLM embedding path and searches Qdrant collections:

- knowledge
- agent_lessons

The service is intentionally small: Python stdlib http.server plus urllib.

## Runtime

- Host: vm-112
- Bind: 0.0.0.0:8635
- Service dir: /opt/cluster-recall/
- systemd unit: cluster-recall.service
- Secret env: /opt/cluster-recall/.env

RECALL_TOKEN lives in env files only. It must not be committed to this repo.

## Endpoints

### GET /health

Unauthenticated health check.

Expected response: {"ok": true}

### POST /recall

Requires Authorization: Bearer <RECALL_TOKEN>.

Request: {"query": "OPNsense hairpin NAT fix", "k": 5}

Flow:

1. Embed the query with text-embedding-3-small.
2. Search Qdrant knowledge and agent_lessons.
3. Merge by score descending.
4. Return top-k hits with score, collection, source, and truncated text.

### POST /lesson

Requires Authorization: Bearer <RECALL_TOKEN>.

Request: {"text": "lesson text", "agent": "system", "source": "paketA", "tags": []}

Flow:

1. Embed the lesson with text-embedding-3-small.
2. Upsert one UUID point into Qdrant collection agent_lessons.
3. Store payload fields agent, ts, text, source, and tags.

## Agent Rollout Pattern

Each agent host gets only shared-recall access. Existing private memory systems
such as mem0 must not be modified by the rollout.

Pattern:

1. Verify reachability: curl http://10.6.7.22:8635/health.
2. Copy the current RECALL_TOKEN from vm-112 into the agent-local env file.
3. Install cluster_recall wrapper.
4. Add a local-first skill/instruction telling the agent to query shared recall
   before external search.
5. Verify cluster_recall "OPNsense hairpin NAT fix" returns JSON.

Current rollout scripts:

- rollout_vm101.sh for Hermes vm-101
- rollout_vm200.sh for Paperclip vm-200

For Hermes-style agents, use hermes-SKILL.md as the skill template.
For OpenClaw/vm-100, use the same wrapper pattern with its own local env path.
