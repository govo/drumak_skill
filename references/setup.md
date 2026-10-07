# Setup: install, requirements, configuration, troubleshooting

This is the technical companion to `README.md`. Everything here is about getting the service reachable and
keeping it that way; protocol details for each channel are in `channels.md`, and tool behaviour is in `tools.md`.

There is nothing to install on the Drum AI app side — the app is a normal App Store download.

---

## 1. Requirements

- **The default address is the public deployment at `https://c1c1.online/drumai_mcp`.** It works out of the box,
  with no need to run your own server.
- **Node.js 20 or newer**, if you use the script channel. `scripts/call.sh` uses node to assemble JSON and parse responses.
- The script channel needs only `curl` and `node`; no extra packages to install.
- The MCP channel needs nothing beyond an MCP-capable client.

Smoke check — if this answers, the service is up:

```bash
curl -s https://c1c1.online/drumai_mcp/healthz
# {"ok":true,"version":"0.1.0","kits":24,"presets":50,"styleTemplates":8,"tools":19}
```

---

## 2. Installing the skill

### Claude Code, as a plugin

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

Outside a session the same two steps are:

```bash
claude plugin marketplace add govo/drumak_skill
claude plugin install drumai-preset@drumai
```

The plugin carries its own `.mcp.json`, so the MCP server registers automatically.

Once installed:

- Saying "make a 140 BPM beat with a trap kit" triggers this skill;
- `/mcp` shows the server `plugin:drumai-preset:drumai-preset`;
- Tools are exposed as `mcp__plugin_drumai-preset_drumai-preset__<tool name>`.

`claude plugin list` should show `drumai-preset@drumai` as enabled. To pick up new versions later, run
`claude plugin marketplace update drumai`; to disable temporarily, `claude plugin disable drumai-preset@drumai`.

### Claude Code, as a plain checkout

If you would rather have files you can read and edit:

```bash
git clone https://github.com/govo/drumak_skill.git ~/.claude/skills/drumai-preset
```

**The target directory has to be named exactly `drumai-preset`.** Claude Code requires a skill directory name to match the
`name` field in `SKILL.md`, and that name may only contain `a-z`, `0-9` and `-`. A checkout in a differently-named directory
will not load.

Loaded this way the plugin id is `drumai-preset@skills-dir`, and the `.mcp.json` inside it takes effect with it — so the MCP
server registers automatically here too, with no extra configuration.

If you already have a checkout somewhere else (for example a working copy you develop in), symlink it in instead of cloning:

```bash
ln -s /absolute/path/to/your/checkout ~/.claude/skills/drumai-preset
```

The symlink name is what takes effect, so it must also be `drumai-preset`. Delete the symlink to uninstall.

### Other MCP clients

Clients other than Claude Code do not have the `${CLAUDE_SKILL_DIR}` variable; replace it with the absolute path of this skill
directory. The `${DRUMAI_MCP_URL:-...}` form with a default value in `.mcp.json` is not supported by every client either — if
yours does not support it, hardcode the address. You need to register the server in the client's own config; see `channels.md`.

For clients like ChatGPT that cannot read local files, see section 5 below.

---

## 3. Configuration

The address is configured in exactly one place: **the `DRUMAI_MCP_URL` environment variable**. If it is not set, the default
public address is used; the `.env` in this directory is the on-disk version of that address.

```bash
cp .env.example .env      # first time
```

Contents of `.env`:

```
DRUMAI_MCP_URL=https://c1c1.online/drumai_mcp
```

The value can be a bare address or a full endpoint (the script appends `/mcp` itself).

Resolution order: **the `DRUMAI_MCP_URL` environment variable > `.env` > the default `https://c1c1.online/drumai_mcp`**.

How each of the two channels obtains this value:

| Channel | Who resolves it |
| --- | --- |
| MCP tools | `${DRUMAI_MCP_URL:-https://c1c1.online/drumai_mcp}` in `.mcp.json`, resolved by Claude Code |
| Script | `scripts/call.sh` resolves it itself (environment variable first, then `.env`) |

To point at a different service temporarily, no file edits needed:

```bash
DRUMAI_MCP_URL=https://your-host bash scripts/call.sh list_kits '{}'
```

**`.env` is never committed** — `.gitignore` already excludes `.env`, `.env.local`, and `.env.*.local`.
What you commit is `.env.example`.

> To make the MCP channel use a non-default address as well: `.mcp.json` reads **the environment variables of the Claude Code
> process**; it does not read the `.env` file. So `export DRUMAI_MCP_URL=...` in your shell before starting `claude`, or put it in
> the `env` block of `~/.claude/settings.json`. When both are set, the settings `env` wins.

---

## 4. Choosing among the three channels

| Scenario | Which channel | How to use it |
| --- | --- | --- |
| MCP already configured in the client | **MCP tools** | Call them directly — full capability, 19 tools. Tool names are `create_draft` and the like |
| Client does not support MCP but can run a shell | **Script channel** | `bash scripts/call.sh <tool name> '<JSON>'` — same capability as MCP |
| Neither | **Raw JSON-RPC** | POST to `<address>/mcp` yourself; protocol details in `channels.md` |

All three channels go through the same tool registry and have exactly the same capability.

**Where the address comes from**: the MCP tools channel is declared by `.mcp.json` (Claude Code reads it automatically, no manual
setup); the script and raw JSON-RPC channels are determined by `DRUMAI_MCP_URL` / `.env` — a separate source from `.mcp.json`, and
the two do not affect each other.

### Script cheat sheet

```bash
# run from the skill directory; inside Claude Code this is $CLAUDE_SKILL_DIR
S=scripts

bash $S/call.sh --list                                  # list all tool names
bash $S/call.sh list_kits '{"style":"trap"}'            # find kits by style
bash $S/call.sh get_kit '{"kitId":"kit-10"}'            # get the voice table (required before writing patterns)

bash $S/call.sh create_draft '{"kit":"kit-10","name":"My Beat","bpm":140,"bars":2}'
bash $S/call.sh set_voice_grid '{"draftId":"d_xxx","voices":[{"index":0,"triggers":"x---x---x---x---"}]}'
bash $S/call.sh render_preset '{"draftId":"d_xxx"}'
```

Data goes to stdout; diagnostics go to stderr.

Exit codes:

| Code | stderr prefix | Meaning |
| --- | --- | --- |
| `0` | — | success |
| `1` | `Tool error:` | the tool itself reported an error (invalid arguments, failed validation) — **a normal result, fix the arguments and retry** |
| `1` | `Cannot reach the service:` | the service is not running, or the address is wrong |
| `1` | `The service did not return an MCP response` | the endpoint was given as the root path; it should be `<address>/mcp` |
| `1` | `RPC error:` | a protocol-level error, usually a nonexistent tool name |
| `2` | — | usage error (the argument is not valid JSON, or an argument is missing) |

---

## 5. For ChatGPT / remote AI clients

The public deployment at `https://c1c1.online/drumai_mcp` is already reachable from outside, so remote clients can connect to it
directly. The three items below only apply when you **deploy it yourself**.

### Three prerequisites for self-hosting

1. **The service must listen on all interfaces**, or other machines cannot connect. By default it binds to the loopback address
   only; to expose it you have to change the startup parameters:

   ```bash
   HOST=0.0.0.0 PORT=8787 PUBLIC_BASE_URL=https://your-domain npm start
   ```

   Or use a tunnel / reverse proxy.

2. **This service has no authentication whatsoever.** Anyone who can reach it can generate PRESET links and create drafts.
   Prefer a tunnel with access control (such as Cloudflare Tunnel + Access), and **do not expose the port raw to the public internet**.

3. **`PUBLIC_BASE_URL` determines the host of the links.** If it is not set, the link returned by `render_preset` points at the
   machine the service itself runs on, and **only that machine can open it**.
   When a remote user cannot open the link, check this setting first — do not suspect a mistyped parameter.

### How to tell ChatGPT the address

ChatGPT cannot read your local files, so you have to feed it manually. Pick one of the two:

- **Say it in the conversation**: "the service address is `http://xxx`", then paste the contents of `SKILL.md`,
  `tools.md`, and `footguns.md` to it.
- **Project knowledge / a custom GPT**: upload `SKILL.md` and the files under `references/` as knowledge files,
  and state the service address in the instructions.

`${CLAUDE_SKILL_DIR}` in `SKILL.md` is a Claude Code-specific variable; when using this with ChatGPT, replace it with the actual
path, or ignore it (raw JSON-RPC works with plain curl and does not depend on the script).

### What a remote AI can and cannot do

It can write patterns, add fills, apply style templates, work out velocity and ratchet/flam detail, and produce the link. It
**cannot** import the PRESET into the app for the user — that step has to be done by the user tapping the link on their phone.

---

## 6. Running your own server

Only needed if you are changing the server code or want to run everything on your own machine. The server source lives in the
`mcp/` directory of the drummy repository:

```bash
cd <drummy>/mcp
npm install
npm run dev          # local development, listens on port 8787 by default
```

Once it is running, put the address in `.env` (see section 3), or override it on the spot with `DRUMAI_MCP_URL`.

Note that a self-hosted server that has not set `PUBLIC_BASE_URL` produces links pointing at its own loopback address, which
only that machine can open — see section 5.

---

## 7. Troubleshooting

| Symptom | Cause |
| --- | --- |
| `Cannot reach the service:` | the service is not started, or the address is wrong (`.env` / `DRUMAI_MCP_URL`). Try `curl <address>/healthz` first |
| `The service did not return an MCP response` | the endpoint is missing `/mcp` and hit the root path or some other path |
| `草稿不存在或已过期` | drafts live in service process memory; they expire after 2 hours and are lost on restart. Run `create_draft` again |
| The user cannot open the link from `render_preset` | `PUBLIC_BASE_URL` is not set on the server, so the link points at the service's own local address |
| The tool returns `isError` but the reason is unclear | Read `issues[].path` and `code` in the response and compare against section 5 of `references/tools.md` |
| The pattern you wrote is not the one you wanted | You most likely hit something in the `hits`-repeats-per-bar family of footguns; see `references/footguns.md` |
| `render_preset` reports `spec 校验未通过` | Run `validate_draft` first; it is usually an empty grid or a step-count mismatch |
