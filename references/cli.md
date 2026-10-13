# The `drumai` CLI

The CLI is the **preferred channel**. It runs entirely on the user's own machine: no service to
reach, no address to configure, no network at all for building a pattern. It also adds commands that
talk to the app directly — transport control, pushing a pattern in, reading back what is loaded —
which no other channel can do.

Reach for it first (see §1 of `SKILL.md`). Fall back to the MCP tools when the CLI is not installed.

---

## 1. Install

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
drumai version
```

**All three lines are needed.** Homebrew 6 and later refuse to load a formula from a third-party tap
until it is trusted, so dropping the `brew trust` line fails with
`Refusing to load formula govo/tap/drumai from untrusted tap`. (On Homebrew older than 6 there is no
`trust` subcommand — drop that one line and the rest works as is.)

`govo/tap` contains nothing but `drumai`, so trusting the tap trusts nothing else.

Alternative without Homebrew — the binaries are on
[Releases](https://github.com/govo/drumai-cli/releases/latest), one per architecture:

```bash
tar -xzf drumai-0.1.0-darwin-arm64.tar.gz     # or -x64 on Intel
sudo mv drumai /usr/local/bin/
```

Both binaries are signed with a Developer ID certificate and notarized by Apple, so Gatekeeper
accepts them. macOS 13 or later; **Node.js is not required** — the binary embeds its own runtime.

Check what you have:

```bash
command -v drumai && drumai version
```

If that prints nothing, the CLI is not installed. Do not silently fall back mid-task — tell the user
the CLI would be the better path and offer the three install lines above; meanwhile you can carry on
with the MCP tools so the user still gets their beat.

---

## 2. What it does that the MCP tools do not

| | MCP tools | `drumai` CLI |
| --- | --- | --- |
| Needs the service reachable | yes | **no** — fully local |
| Needs the address configured | yes | no |
| Pattern building, fills, styles, rendering | yes | yes, same 19 operations |
| Draft storage | server process memory, 2-hour TTL | **local file**, no expiry |
| Sees the app's own PRESETs and kits on disk | no | yes (`current`, `preset`, `live`) |
| Starts and stops playback in the app | no | yes (`play` / `stop` / `toggle`) |
| Pushes a pattern into the app without a link | no | yes (`apply`, `live`) |
| Turns a link into a file the user opens | link only | link only (same) |

The last three rows are the interesting ones: with the CLI you can hand the user a link **or** put the
pattern straight into the app yourself when the app is running on the same Mac.

---

## 3. Conventions

**Every command takes `--help`.** That is the authoritative usage line for that command —
`drumai draft create --help` prints its exact flags. Prefer reading it over guessing.

**Input and output are JSON.** Output is JSON on stdout, diagnostics on stderr, so it pipes into
`jq` or into a second `drumai` call.

**Passing a complex argument.** Anywhere a flag takes JSON, three forms work:

| Form | Meaning |
| --- | --- |
| `--voices '[{"index":0,...}]'` | inline JSON |
| `--voices @args.json` | read the JSON from a file |
| `--voices -` | read the JSON from stdin |

`--args <file|->` and `--json-body '<json>'` pass a **whole argument object** at once, for when the
inline form gets unwieldy:

```bash
drumai draft voice d_abc --json-body '{"voices":[{"index":0,"triggers":"x---x---x---x---"}]}'
```

**Exit codes** — the same four as everywhere else in this skill:

| Code | Meaning |
| --- | --- |
| `0` | success |
| `1` | the tool itself refused (bad arguments, failed validation) — **a normal result, fix and retry** |
| `2` | usage error (malformed JSON, missing argument) |
| `3` | environment error |
| `4` | internal error |

**Language.** The CLI follows the app's own language setting, then the system, then English. Output
language does not change the JSON field names.

**Command aliases.** `create` = `draft create`, `voice` = `draft voice`, `get-kit` = `kit`,
`render-preset` = `render`, and so on — the short forms are listed by `drumai <command> --help`.

---

## 4. Command map

The generation half is a 1:1 mirror of the MCP tools. When you already know the MCP call, this table
gives you the CLI spelling.

| MCP tool | CLI |
| --- | --- |
| `list_kits` | `drumai kits [--style trap] [--instruments]` |
| `get_kit` | `drumai kit kit-10` |
| `list_grid_options` | `drumai grid [--ts 4/4] [--cells 4]` |
| `list_fill_modes` | `drumai fills` |
| `list_style_templates` | `drumai styles` |
| `list_reference_presets` | `drumai presets` |
| `get_reference_preset` | `drumai presets show preset-slime-time` |
| `create_draft` | `drumai draft create --kit kit-10 --name "My Beat" --bpm 140 [--ts 4/4] [--cells 4] [--bars 2] [--groove swing:0.35] [--humanize 0.2] [--from-preset preset-x] [--tags trap,hiphop]` |
| `set_voice_grid` | `drumai draft voice <draftId> --voices '[...]' [--variation 0] [--mode replace\|append]` |
| `apply_fill_mode` | `drumai draft fill <draftId> --mode sixteenth --voices '[{"role":"hat"}]' [--seed 7] [--variation 0]` |
| `apply_style_template` | `drumai draft style <draftId> --template house [--only kick,snare] [--variation 0]` |
| `update_draft` | `drumai draft update <draftId> [--bpm N] [--bars N] [--tags a,b] [--master @f] [--voices @f] ...` |
| `get_draft` | `drumai draft show <draftId>` |
| `validate_draft` | `drumai draft validate <draftId> \| --spec @file.json` |
| `list_drafts` | `drumai draft list` |
| `delete_draft` | `drumai draft rm <draftId>` |
| `render_preset` | `drumai render <draftId> \| --draft <id> \| --spec @file.json [--include url,preview]` |
| `parse_preset` | `drumai parse --input "DHP2;..." \| --input @share.txt \| --input -` |
| `render_wireframe` | `drumai wireframe --input "DHP2;..." \| --input @share.txt \| --input -` |

Everything in `SKILL.md` §4 about **how** to write a pattern applies unchanged — the grid strings,
`hits`, velocities, ratchets, flams, `cellsPerQuarter`, and every footgun are properties of the
underlying engine, not of the channel. Only the calling syntax differs.

### Escape hatch

Anything not surfaced as its own subcommand is reachable through `call`, whose arguments are exactly
the MCP tool's:

```bash
drumai call list_fill_modes '{}'
drumai call set_voice_grid '{"draftId":"d_abc","voices":[...]}'
```

Self-inspection, for when you need to confirm what this build supports:

```bash
drumai tools          # every MCP tool and CLI command, machine-readable
drumai schema list_kits   # the JSON Schema for one tool's arguments
drumai instructions   # the same construction-rules document the MCP server sends on initialize
```

`drumai instructions` is worth knowing: on the CLI channel you never receive an `initialize`, so
this is how you read the musical rules if you want them.

---

## 5. A full run

```bash
# 1. pick a kit and read its voice table — indices are per kit, always check
drumai kits --style trap
drumai kit kit-10

# 2. create the draft
D=$(drumai draft create --kit kit-10 --name "Trap 140" --bpm 140 --bars 2 --tags trap,hiphop \
      | jq -r .draftId)

# 3. write the pattern — all voices in one call
drumai draft voice "$D" --voices '[
  {"index":0,"triggers":"x-----x---x-----x-----x---x-----"},
  {"index":2,"triggers":"--------x---------------x-------"},
  {"index":4,"triggers":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
   "ratchets":"------------r-r-----------------",
   "velocities":{"0":1,"2":0.6,"4":0.75,"8":1,"12":0.7}}]'

# 4. self-check
drumai draft validate "$D"

# 5. get the links
drumai render "$D"
```

Steps 2 through 5 are the same musical work the MCP flow does; the only difference is that the draft
lives in `~/.drumai/drafts.json` on the user's machine instead of in the service's memory.

---

## 6. Delivering the link — read this before you render

`render` returns the same two links as `render_preset`, but **the host of `url` comes from the CLI's
own environment, not from the service**:

| Environment variable | `url` becomes |
| --- | --- |
| unset | `http://localhost:8787/p?p=...` — **only opens on the machine that runs a local service** |
| `PUBLIC_BASE_URL=https://c1c1.online/drumai_mcp` | `https://c1c1.online/drumai_mcp/p?p=...` — opens anywhere |

The payload is built locally and is byte-compatible with the public service: a payload the CLI
produced opens on the public landing page. So on a plain `brew install` with nothing configured, the
web link is a loopback address that the user's phone cannot open.

**`deeplink` is unaffected** — `drumai://import?p=<payload>` carries the whole payload inside itself
and needs no server at all. On the CLI channel, **lead with the deeplink** and present the web link
as the fallback, not the other way round.

If you want a working web link too, set the variable for the call:

```bash
PUBLIC_BASE_URL=https://c1c1.online/drumai_mcp drumai render "$D"
```

If the `url` comes back pointing at `localhost` or `127.0.0.1`, say so plainly to the user rather
than handing over a dead link — and give them the deeplink, which works regardless. Do not "fix" the
host by editing the URL text; the payload is fine, only the prefix is local.

---

## 7. Drafts are local, and separate from the MCP service's drafts

This is the one place where mixing channels silently breaks:

- A draft id from `drumai draft create` lives in `~/.drumai/drafts.json` (override the directory with
  `DRUMAI_HOME`) and never expires.
- A draft id from the MCP `create_draft` lives in the service process's memory, expires after 2
  hours, and is lost when the service restarts.

The two stores do not see each other. **A draft id from one channel cannot be used on the other** —
you get "the draft does not exist or has expired". Pick a channel at the start of the job and stay on
it; if you have to switch, rebuild the draft on the new channel rather than reusing the id.

Drafts are identified as `d_xxxxxxx` on both, so the ids look interchangeable. They are not.

---

## 8. Driving the app (CLI only)

These commands need Drum AI running — in the Simulator or on the Mac — and they find it themselves.
`drumai target` reports what was found, `drumai doctor` reports everything including whether the
app's container is readable.

| Command | What it does |
| --- | --- |
| `drumai target` | Show or set which app instance to control (simulator / Mac) |
| `drumai play` / `stop` / `toggle` | Transport control |
| `drumai preset <id>` | Switch the app to a PRESET |
| `drumai kit-use <id>` | Switch the current kit |
| `drumai reload` | Make the app rescan its user PRESET and kit folders |
| `drumai current` | Read the app's current content as a spec, including unsaved edits (`--wireframe` for a score) |
| `drumai apply` | Write a draft / spec / payload into the app's current PRESET **in place**; creates nothing, only `--save` writes to disk |
| `drumai live open\|push\|show\|save` | Edit one PRESET across several calls: `open` reads it into a draft, `push` sends it back, `save` writes it to disk |

Two uses worth remembering:

- **Hear it before delivering.** After writing a pattern, `drumai apply --draft "$D"` puts it into
  the app, then `drumai play` lets the user listen — no link, no import tap. Say that you did it.
- **Edit what the user already has.** `drumai current --wireframe` shows the pattern loaded in the
  app, and `drumai live open` picks it up as an editable draft. That is the shortest path for "change
  the beat I have open right now".

`apply` writes in place and **creates nothing**; without `--save` it touches only the app's edit
buffer, so it is safe to try. Use `--dry-run` to see what would change without changing it.

---

## 9. Troubleshooting

| Symptom | Cause |
| --- | --- |
| `drumai: command not found` | Not installed, or not on `PATH`. Offer the three install lines in §1 |
| `The draft does not exist or has expired` right after creating it | The id came from the other channel — see §7 |
| The web link points at `localhost:8787` | `PUBLIC_BASE_URL` is unset — see §6. Give the deeplink instead |
| `draft validate` says invalid | Same causes as on the MCP channel: empty grid, step-count mismatch (`references/footguns.md`) |
| App commands fail, or `doctor` shows no target | Drum AI is not running, or `sessionReadable` is false. Ask the user to launch the app |
| Output is in an unexpected language | `drumai lang` reports the current language and which layer chose it; `drumai --lang en <command>` overrides it for one call; `drumai lang en` makes it stick, `drumai lang auto` goes back to following the app |
