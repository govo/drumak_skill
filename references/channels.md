# Three channels: how to connect to this service

All three channels go through the **same tool registry** (the 19 tools registered in the same `mcp.ts`),
with identical capabilities; the only difference is "how far your client can go". Follow the order in the first section of SKILL.md and pick the first one that works.

Service endpoints at a glance (the default address is `https://c1c1.online/drumai_mcp`, already declared in the `.mcp.json`
that ships with this skill; see `.env` when switching to a self-hosted service):

| Endpoint | Method | Purpose |
| --- | --- | --- |
| `/mcp` | POST | MCP protocol endpoint (tool channel) |
| `/p?p=<payload>` | GET | Landing page, the link the user opens |
| `/p.txt?p=<payload>` | GET | Plain-text DHP2 output, for scripts. No link to it from the landing page |
| `/healthz` | GET | Health check, returns the version and kit count |

Smoke check:

```bash
curl -s https://c1c1.online/drumai_mcp/healthz
# {"ok":true,"version":"0.1.0","kits":24,"presets":22,"styleTemplates":8,"tools":19}
```

---

## Channel 1: MCP client (preferred)

**Claude Code uses the `.mcp.json` that ships with this skill — no hand-written config needed** — as long as this skill is installed
as a plugin (see the installation section of `README.md`), the `drumai-preset` server is registered automatically.

Other clients (Claude Desktop, Cursor, etc.) need to add a block to their own configuration:

```json
{
  "mcpServers": {
    "drumai-preset": {
      "type": "http",
      "url": "https://c1c1.online/drumai_mcp/mcp"
    }
  }
}
```

`type` cannot be omitted — a bare `url` is treated as a stdio server and skipped. Replace this address with your actual
`DRUMAI_MCP_URL` (for a bare address, append `/mcp` yourself).

Once connected, the tool names are `create_draft`, `set_voice_grid`, and so on — call them directly.
On `initialize`, the server delivers the "Drum AI PRESET Construction Rules" through `instructions` — **read it**;
it contains the style parameter table and kit-selection advice.

Tool names are case-sensitive and carry no prefix; do not write things like `mcp__drumai__create_draft`.

---

## Channel 2: script channel (you can run a shell but have no MCP client)

```bash
bash scripts/call.sh <tool name> '<JSON args>'
bash scripts/call.sh --list          # list all tool names
```

What the script does: it assembles `<tool name> + <JSON args>` into a JSON-RPC request, POSTs it to `<address>/mcp`,
then prints the `content[0].text` that comes back.

- Success: stdout is the JSON text returned by the tool, exit code 0.
- **The tool itself reports an error** (invalid arguments, failed validation): stderr, with the prefix `Tool error:`, exit code 1.
  This is a **normal result** — it means the arguments need changing, not that the channel is broken.
- **Channel failure** (RPC error, wrong address): stderr, with the prefix `RPC error:` or "The service did not return an MCP response".

---

## Channel 3: raw JSON-RPC (self-built agents, script pipelines)

The server exposes a **stateless compatibility path** on `/mcp`, so **there is no need to call `initialize` first** —
you can call `tools/call` and `tools/list` directly. Verified in practice.

```bash
curl -s -X POST https://c1c1.online/drumai_mcp/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"list_grid_options","arguments":{"timeSignature":"4/4","cellsPerQuarter":4}}}'
```

Two things require attention:

1. **The `accept` header must include `text/event-stream`.** The response is usually SSE-wrapped:

   ```
   event: message
   data: {"result":{"content":[{"type":"text","text":"{...}"}]}}
   ```

   Parse the part after `data: `. Do not assume it is always plain JSON.

2. **Two levels of JSON nesting.** What the tool returns is the MCP content structure, and the real payload is in
   `result.content[0].text` — and that is **a string**, which must be `JSON.parse`d once more.

Errors fall into two categories, handled differently:

| Symptom | Meaning | What to do |
| --- | --- | --- |
| `result.isError === true` | The tool function itself reports an error (invalid arguments, failed validation, kit not found) | A normal result; read `error` and `issues` inside `content[0].text`, change the arguments and retry |
| Top-level `error` field | Protocol-level error (tool name does not exist, malformed request) | The client must catch it; usually you mistyped the tool name |

---

## Addresses and security

- The default address `https://c1c1.online/drumai_mcp` is a public deployment and works as is. When connecting to a self-hosted service, note:
  the service binds to the loopback address only by default, so **other machines cannot reach it — that is expected**; the server side must set
  `HOST=0.0.0.0` or expose it through a reverse proxy or tunnel.
- The service has **no authentication whatsoever**. Anyone who can reach it can generate PRESET links and create drafts. When exposing a
  self-hosted service to the outside, prefer a tunnel with access control; do not leave the port raw-exposed.
- The host in the links is determined by the server-side environment variable `PUBLIC_BASE_URL`, and has nothing to do with which address the client
  connects to. If a user cannot open the link that `render_preset` returns, check that item first.
