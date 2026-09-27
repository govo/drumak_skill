#!/usr/bin/env bash
#
# call.sh — call the Drum AI PRESET MCP directly over JSON-RPC, without an MCP client.
#
#   bash scripts/call.sh <tool-name> '<JSON arguments>'
#   bash scripts/call.sh list_kits '{"style":"trap"}'
#   bash scripts/call.sh --list                      # list every tool name
#
# For cases where you can run a shell but the client does not support MCP (custom agents, script
# pipelines). Capability is identical to the MCP channel -- same /mcp endpoint, same tool registry.
#
# Endpoint: environment variable DRUMAI_MCP_URL > DRUMAI_MCP_URL in this directory's .env
#           > https://c1c1.online/drumai_mcp
# The server exposes a stateless compatibility path there, so there is no need to initialize first --
# call tools/call directly.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$HERE")"

DEFAULT_BASE="https://c1c1.online/drumai_mcp"

# Read one key out of .env. Deliberately not sourced: .env is a plain config file and should not be
# executed as a script, and sourcing would misbehave under set -u with spaces/quotes in values.
env_file_value() {
  local key="$1" file="$2" raw
  [ -f "$file" ] || return 0
  raw="$(sed -n "s/^[[:space:]]*${key}[[:space:]]*=[[:space:]]*//p" "$file" | tail -1)"
  # strip trailing whitespace and matched surrounding quotes
  printf '%s' "$raw" | sed 's/[[:space:]]*$//; s/^"\(.*\)"$/\1/; s/^'"'"'\(.*\)'"'"'$/\1/'
}

BASE="${DRUMAI_MCP_URL:-}"
if [ -z "$BASE" ]; then
  BASE="$(env_file_value DRUMAI_MCP_URL "$SKILL_DIR/.env")"
fi
[ -n "$BASE" ] || BASE="$DEFAULT_BASE"

# Accept either a full endpoint or a bare address
case "$BASE" in
  */mcp) ENDPOINT="$BASE" ;;
  */)    ENDPOINT="${BASE%/}/mcp" ;;
  *)     ENDPOINT="$BASE/mcp" ;;
esac

# healthz lives at the service root, not under /mcp -- the hint needs the endpoint reduced back to
# the root address.
HINT_BASE="${BASE%/}"
HINT_BASE="${HINT_BASE%/mcp}"

rpc() {
  # curl's own error goes to stderr and would be swallowed by the downstream JSON parse, surfacing
  # as "cannot parse the response" -- which sends the caller hunting for a mistyped endpoint.
  # So translate connection failures into something clear right here.
  local response errorFile
  errorFile="$(mktemp)"
  if ! response="$(curl -sS -m 60 -X POST "$ENDPOINT" \
      -H 'content-type: application/json' \
      -H 'accept: application/json, text/event-stream' \
      -d "$1" 2>"$errorFile")"; then
    echo "Cannot reach the service: $ENDPOINT" >&2
    sed 's/^/  /' "$errorFile" >&2
    echo "  Check: is the service running (curl ${HINT_BASE}/healthz), and is .env or DRUMAI_MCP_URL correct?" >&2
    rm -f "$errorFile"
    exit 1
  fi
  rm -f "$errorFile"
  printf '%s' "$response"
}

# The response may be plain JSON or SSE (event: message / data: {...}); accept both.
unwrap() {
  node -e '
let raw = "";
process.stdin.on("data", (d) => (raw += d)).on("end", () => {
  const text = raw.trim();
  const line = text.startsWith("event:")
    ? text.split("\n").find((l) => l.startsWith("data: "))
    : null;
  let payload;
  try {
    payload = JSON.parse(line ? line.slice(6) : text);
  } catch {
    console.error(
      "The service did not return an MCP response (check that the endpoint is <baseUrl>/mcp, not the root path):\n" +
        (text.length > 0 ? text.slice(0, 500) : "(empty response)"),
    );
    process.exit(1);
  }
  if (payload.error) {
    console.error("RPC error: " + JSON.stringify(payload.error));
    process.exit(1);
  }
  const content = payload.result?.content?.[0]?.text ?? JSON.stringify(payload.result);
  if (payload.result?.isError) {
    // An error from the tool itself (bad arguments, failed validation, ...). A normal result, not a
    // channel failure.
    console.error("Tool error: " + content);
    process.exit(1);
  }
  console.log(content);
});
'
}

# Use command substitution rather than piping into unwrap: in a pipeline, rpc's exit only ends the
# subshell, and unwrap would still run once on empty input -- so a single connection failure printed
# two contradictory messages. A failed assignment is terminated directly by set -e.
if [ "${1:-}" = "--list" ]; then
  response="$(rpc '{"jsonrpc":"2.0","id":1,"method":"tools/list"}')"
  # When unwrap fails it exits 1 itself, the assignment fails, and set -e terminates. This
  # intermediate step cannot be collapsed into a pipeline: with `unwrap | node`, unwrap exiting
  # leaves the downstream node with empty input, which throws a SyntaxError stack -- so one
  # connection failure printed two conflicting errors.
  tools="$(printf '%s' "$response" | unwrap)"
  printf '%s' "$tools" |
    node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const j=JSON.parse(s);for(const t of j.tools)console.log(t.name)})'
  exit 0
fi

if [ $# -lt 2 ]; then
  echo "Usage: bash scripts/call.sh <tool-name> '<JSON arguments>'" >&2
  echo "       bash scripts/call.sh --list" >&2
  exit 2
fi

TOOL="$1"
ARGS="$2"

# Build the request body with node to avoid hand-rolled JSON escaping bugs.
BODY="$(node -e '
const [tool, argsJson] = process.argv.slice(1);
let args;
try {
  args = JSON.parse(argsJson);
} catch (error) {
  console.error("Second argument is not valid JSON: " + error.message);
  process.exit(2);
}
process.stdout.write(JSON.stringify({ jsonrpc: "2.0", id: 1, method: "tools/call", params: { name: tool, arguments: args } }));
' "$TOOL" "$ARGS")"

response="$(rpc "$BODY")"
printf '%s' "$response" | unwrap
