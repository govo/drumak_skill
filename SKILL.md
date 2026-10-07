---
name: drumai-preset
description: Turn "the beat I want" into a PRESET that imports into the Drum AI drum machine app, using the Drum AI PRESET MCP service — pick a kit, write the pattern, add ratchet / flam / velocity detail, and return a clickable web preview link plus a direct drumai:// app import link. Use when the user asks to create, edit, or analyze a drum pattern / drum preset / drum beat / drum groove; to make a beat in a style such as trap, house, funk, boom bap, techno, breakbeat, shuffle, or metal / double bass; to rework an existing PRESET; or to parse a pasted PRESET share text. For the Drum AI drum machine app.
metadata:
  version: "1.1"
compatibility: Requires the Drum AI Preset MCP service to be reachable; the script channel additionally needs curl and Node.js 20 or newer.
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/*) mcp__plugin_drumai-preset_drumai-preset__*
---

# Drum AI PRESET MCP

Drum AI is a drum machine app. This MCP service exposes the app's drum-sequencing engine: the pattern
you write here becomes a link, and the user opens that link to import the pattern into the app and hear it.

**What you deliver is always a link** — not a prose description, not a JSON blob. The user has not
received anything until they have the link. `render_preset` hands you **two** links carrying the same
payload: the `https://` landing page and a `drumai://` app deep link. Give both (see §6).

```
User says "make me a trap beat"
  → you call the tools
  → render_preset returns url + deeplink (same payload, built server-side)
  → user taps the deeplink → app opens with the import panel pre-filled → taps Import → hears it
  → or opens the url → preview page → Open in App / copy → import
```

On `initialize`, the server sends down a "Drum AI PRESET Construction Rules" document (musical rules,
per-genre parameter table, kit-picking advice). That document is the musical guidance; this skill is the
operational layer: which tools to call, how to fill the parameters correctly, and which writing patterns
will bite you. Where the two conflict, the actual tool behavior — as described in this skill and in the
tool responses — wins.

## 1. First, decide which channel to use

Check in order and take the **first one that works**:

1. **Are `create_draft`, `set_voice_grid` and friends already in your tool list?**
   → Call them directly. This is the primary channel: 19 tools, full capability.

2. **Can you run a local shell?**
   → Use the script channel (same `/mcp` endpoint, same tool registry, identical capability):

   ```bash
   bash ${CLAUDE_SKILL_DIR}/scripts/call.sh <tool-name> '<JSON arguments>'
   bash ${CLAUDE_SKILL_DIR}/scripts/call.sh list_kits '{"style":"trap"}'
   bash ${CLAUDE_SKILL_DIR}/scripts/call.sh --list        # list every tool name
   ```

   (The script can be invoked from any directory — it locates `.env` relative to itself. Do not `cd`
   into the skill directory first.)

3. **Neither?**
   → Have the user set up an MCP client, or give you the service address so you can POST JSON-RPC to
   `<address>/mcp` yourself (protocol details in `references/channels.md`).

**If you cannot reach the service, ask the user for the address — do not blindly try other ports.**
The default address points at a public deployment; a failure is usually either the other side's
self-hosted service being down, or the user wanting an address different from the default.

## 2. Address and configuration

**On channel 1 (MCP tools) you do not need to know the address** — the tools are already registered,
just call them. The address is declared in the `.mcp.json` that ships with this skill and resolved by
the client; it is not repeated in this document.

On channel 2 (script) the address is resolved by `scripts/call.sh` itself, in this order:

```
environment variable DRUMAI_MCP_URL  >  DRUMAI_MCP_URL in this directory's .env  >  https://c1c1.online/drumai_mcp
```

The value may be a bare address (`https://c1c1.online/drumai_mcp` — the script appends `/mcp` itself)
or a full endpoint; both are accepted.

If you cannot connect, first `curl <address>/healthz` to confirm the service is running, then ask the
user for the correct address — **do not blindly try other ports**. The default is a public deployment;
if the user runs their own, their address wins.

Non-Claude-Code clients have no `${CLAUDE_SKILL_DIR}` variable — replace it with the absolute path of
this skill directory. The `${DRUMAI_MCP_URL:-...}` form in `.mcp.json` is also not supported by every
client; where it is not, hardcode the address.

**About the link you produce**: `render_preset` builds the link from the **server's** environment
variable `PUBLIC_BASE_URL`. If that is unset, the link points at whatever machine the server runs on —
**openable only from that machine**.

**You cannot probe this**: no tool returns it, and it is not in the client config either. Your only
signal is the `url`'s host — if it is a loopback address rather than a domain name, the variable is
unset. When that happens, **tell the user honestly** that the link only opens on that machine and will
not work if they send it to a phone or to someone else — do not doubt your own parameters.

## 3. Standard flow

```
1. list_kits            pick a kit (optionally filtered by style; or ask the user what style they want)
2. get_kit              get that kit's 8 voices, their indices, roles, and usage hints
3. list_grid_options    confirm the steps-per-bar for the time signature × cellsPerQuarter
4. create_draft         create the draft (name / bpm / ts / cellsPerQuarter / bars / groove / humanize / tags)
5. set_voice_grid       write the pattern — your only real musical decision, and the step you iterate on
6. validate_draft       self-check; never ship an empty PRESET
7. render_preset        get url + deeplink and hand both to the user
```

Helpers:

- Nothing to start from and you want a decent skeleton → `apply_style_template` (a whole ensemble,
  auto-mapped to the target kit by role)
- You want the last bar to vary → `apply_fill_mode` (the app's 20 fill modes)
- You want to hear what a good pattern looks like in this app → `list_reference_presets` +
  `get_reference_preset`
- The user pasted a `DHP2;...` string and said "tweak this" → `parse_preset`, edit, then `render_preset`
  (a trailing `tag=` field round-trips: it comes back in `spec.tags` and is written out again)
- The user pasted a `DHP2;...` string and you (or they) just need to **see what it is** — `render_wireframe`
  draws the pattern as a wireframe score, no draft needed. Use it to read a pattern, compare two of them,
  or answer "what is this drum part doing". Use `parse_preset` instead when you intend to edit
- The user explicitly wants a built-in PRESET as the starting point → `create_draft` with `fromPresetId`,
  but **it copies the trigger grid only** (velocities and the master chain do not come along), and
  `bars` is forced to 1 with `name` not changeable. To get more bars, follow the path in footguns item 3
- Batch beats one-at-a-time: write several voices in a single `set_voice_grid` call instead of one call
  per voice

**Tag the style by default.** `create_draft` (and `update_draft`) take a `tags` array labelling the
PRESET's musical style, from a fixed 21-value vocabulary — `rock punk pop funk hiphop trap house techno
lofi jazz latin rnb reggae country blues metal soul disco edm world afrobeat`. The app's PRESET library shows
the tags and lets the user filter by
them, so an untagged PRESET is harder to find again: whenever you can tell what style the beat is, pass the
matching tags (or set them later with `update_draft` once the style becomes clear). The only reason to leave
them out is that you genuinely cannot judge the style — an untagged PRESET is still valid and importable. An
unknown value is **rejected with the list of valid options**. A tag is about style, not about the kit: `trap`
means "this is a trap beat" whatever kit it uses.

Drafts are stateful: they expire after 2 hours, at most 500 are kept, and a dead `draftId` must be
recreated. Try to finish a whole job in one conversation.

## 4. How to write the pattern (the core section)

### 4.1 Two ways to write, pick either

**Grid string**: length equals the total step count, `x` triggers, `-` is silent. Too short and it is
padded with `-` on the right; too long is an error.

```
{"index": 0, "triggers": "x---x---x---x---"}
```

That line is four-on-the-floor for one bar in a 4/4 sixteenth-note grid (16 steps per bar).
**Every JSON example here can be pasted straight into a tool call** — do not add comments to them;
a comment makes them unparseable.

**Position-based triggers** (use this when you are unsure which step an event lands on; do not compute
indices yourself):

```
{"index": 1, "hits": [{"beat": 2, "offset": "downbeat"}, {"beat": 4, "offset": "downbeat"}]}
```

`beat` is a **1-based beat number**; `offset` is the name of a position within the beat, and its allowed
values depend on the grid density — you must use a value from the `offsets` array returned by
`list_grid_options` (at 4 cells per beat these are `downbeat` / `e` / `and` / `a`). Each entry in `hits`
must carry either `step`, or both `beat` and `offset` — never both forms, and never neither.

A hit may also carry `velocity` (`0..1`, default `1`), which is how you write dynamics in this form without
converting anything to a step index — see §4.5:

```
{"index": 1, "hits": [{"beat": 2, "offset": "downbeat", "velocity": 1}, {"beat": 2, "offset": "a", "velocity": 0.4}]}
```

### 4.2 hits repeats per bar; it is not absolute positioning

This is the single easiest place to go wrong: **`hits` cannot target just one bar**. It converts the
position into a step within the bar and then repeats it across **every bar**. `{beat:3, offset:"and"}`
in a 4-bar draft writes four notes.

To write a pattern that **differs bar by bar** (fills, variation), you must use a `triggers` grid
string — that is absolute positioning. Write `bars × stepsPerBar` characters, one bar's worth at a
time, concatenated by hand.

| Goal | What to use |
| --- | --- |
| Every bar identical | `hits` (less fuss) or `triggers`, either works |
| Bar-by-bar variation | `triggers` only |

A related consequence: `{step: 20}` in a "16 steps per bar × 2 bars" draft is not an error — it is
treated as step 4 of the bar (`20 % 16`) and then written once in each bar. **Cross-bar positions are
only expressible with `triggers`.**

### 4.3 Talk about grid density in integers, not note names

`cellsPerQuarter` = **how many cells one quarter note is divided into**. Only 5 values:

| Value | One cell is | Cells per beat under an x/4 time signature |
| --- | --- | --- |
| `2` | an eighth note | 2 |
| `3` | an eighth-note triplet | 3 |
| `4` | a sixteenth note | 4 |
| `6` | a sixteenth-note triplet | 6 |
| `8` | a thirty-second note | 8 |

This anchor is independent of the time signature, so **under an x/8 time signature it does not equal
"cells per beat"** (6/8 with `2` → 6 steps per bar, 3 steps per beat). For any question about "how
many cells per beat / steps per bar / what is this position called", **always consult
`list_grid_options`** — never derive it yourself.

**Triplets are a change of grid density, not a marking**: for triplets, set `cellsPerQuarter: 3` or `6`.

### 4.4 Density is a musical decision: `8` for double bass

The five values are not five levels of detail on one ruler — **they set the shortest note the grid can
express**, and that decides which figures are writable at all. Take 106 BPM as the yardstick:

| `cellsPerQuarter` | one cell is | at 106 BPM | what it makes possible |
| --- | --- | --- | --- |
| `4` | a sixteenth note | 141.5 ms | the default; every recipe in `references/recipes.md` |
| `8` | a thirty-second note | 70.8 ms | double-bass bursts, thirty-second hi-hat and tom work |

The concrete case is a double-bass burst: **six kicks crowded into the space of one beat**. At 8 cells
per beat those six hits are six cells — 0.75 of a beat, which is the figure Sample 1 uses. Written on a
sixteenth grid the same six hits would have to span 1.5 beats: a rhythm twice as slow, because six
sixteenths do not fit inside four sixteenths. The figure simply is not available at that density. That
— not "finer detail" — is what `cellsPerQuarter: 8` buys, and the only reason to reach for it. Worked
example in `references/samples.md` (Sample 1).

What the density costs:

- **Every count doubles, and so does every chance to miscount.** 4/4 at 8 cells per beat is 32 steps
  per bar, so a 2-bar `triggers` row is 64 characters and a 4-bar row is 128. A short row is silently
  padded, not rejected (footguns item 4) — count before you copy.
- **A ratchet is half a cell**, so at this density it is a sixty-fourth note: 35 ms at 106 BPM. Do not
  use ratchets to thicken a dense grid, they turn to mush (footguns item 8).
- **The payload grows with the step count.** A 64-step, 8-voice pattern is 3347 characters of share
  text; the cap is 16384 and the warning threshold is around 330 steps, which is about 10 bars here.
  Footguns item 16 says what that warning does and does not mean.
- **Decide the density before writing the first row.** Changing `cellsPerQuarter` later rebuilds every
  grid (footguns item 10).

Position names come from `list_grid_options` as always — under 4/4 with `8` they are `downbeat` then
`1` through `7`, with `stepsPerBeat: 8`.

### 4.5 Sound detail: per-hit velocity, ratchet, flam

All three sound on playback and all three are **fully supported by the app** — write them, and never ship a
pattern with every hit at the same strength:

- `velocities`: a sparse map; keys are **step indices (0-based)**, values `0..1` (steps you omit are `1.0`).
  **This is your finest control over how the beat is played, and the one to reach for on every pattern** —
  see the section below.
- `ratchets`: `r` adds a second hit **halfway through** that step. This is how you get hi-hat rolls. Unlike
  velocity, a ratchet **cannot be edited in the app's UI**, so it is yours alone to place.
- `flams`: `f` adds a hit **18 milliseconds before** the step (a fixed value, not scaled by BPM). This is how
  you get snare grace notes. Also not editable in the app's UI.

#### Using velocity

A pattern where every hit sits at `1.0` reads as a metronome. Velocity is what makes it read as played, and
you have the whole `0..1` range per voice per step. Two equivalent routes — pick the one matching how you
wrote the triggers.

Grid form, `velocities` keyed by 0-based step index:

```
{ "index": 4, "triggers": "x-x-x-x-x-x-x-x-", "velocities": { "0": 1, "2": 0.55, "4": 0.7, "6": 0.55 } }
```

That is an eighth-note hi-hat with a strong downbeat, a light "and", a medium third and a light fourth — one
line of data, and the groove appears.

Positional form, `velocity` riding on each hit, no step index anywhere:

```
{ "index": 2, "hits": [{ "beat": 2, "offset": "downbeat", "velocity": 1 }, { "beat": 2, "offset": "a", "velocity": 0.4 }] }
```

Same idea written the way §4.1 recommends for triggers, so you never have to convert `beat` / `offset` into
step indices just to add dynamics.

What it buys you:

- **Accents and ghost notes.** Full strength on the backbeat, `0.35-0.6` between: a snare row of
  `{"0": 1, "4": 0.5}` is the difference between a drum machine and a drummer.
- **Hi-hats that breathe.** Alternate a strong and a weak value instead of every hit at 1.
- **A fill that builds.** Raise the values step by step across the last bar (0.5, 0.65, 0.8, 1.0) so the fill
  pushes into the next bar rather than just being more notes.
- **Making room.** Pull a busy hat or percussion row down to `0.4-0.7` so it sits behind the kick and snare.
- **Fixing a wrong emphasis.** "The snare is too loud" or "the hats are stomping on everything" is this knob —
  you do not have to rewrite the grid or swap the kit.

Two limits:

- Velocity is **per step, not per individual hit** — the extra hits a ratchet or flam adds at a step share
  that step's velocity.
- `velocities` keys are 0-based step indices while `hits`' `beat` is a 1-based beat number — **two different
  bases coexist in the same request body; do not mix them.** (`hits.velocity` sidesteps this: it rides on the
  `beat` you already named, so there is no index to get wrong.) `apply_fill_mode` **replaces the whole row** for
  that voice and resets velocities to `1` (existing ratchets / flams survive) — so **apply fills first, then
  build velocity dynamics**.

Nothing here is locked in: the app's sequencer and recognition page both let the user drag a hit's velocity by
hand after import, so what you write is a starting point you are handing them, not a final decision. Say so
when you deliver — it tells the user the dynamics are theirs to keep shaping.

### 4.6 Sound design: the Mixer is a musical decision too

Every voice carries five Mixer parameters — `decay` / `tune` / `filter` / `pan` / `volume` — written through
`update_draft`'s `voices[].params`. This is **not a snare-only technique**: every one of the 8 voices in every
kit is adjustable the same way, and a small nudge is enough to move a voice off "this kit's stock sample" onto a
distinct sound, which in turn changes how the groove reads. Neutral is what `get_kit` reports as each voice's
default — `tune` / `filter` / `decay` / `pan` at `50`, `volume` at `100` (what the app's UI calls **Level**) —
so "turn it up" means above 50, "turn it down" means below 100. Unlike the master chain, voice params **do** come
back from `get_draft`, so you can read back what you set.

| Param | What it does |
| --- | --- |
| `tune` | pitch: up is higher and tighter, down is deeper and heavier |
| `filter` | tone and body: up thins the sound out, down gives it more body |
| `volume` | the app's Level — how far forward the voice sits in the mix |
| `decay` | how long the hit rings |
| `pan` | placement left to right |

Two things to know before you touch them:

- **Params are per voice, per draft — not per step.** Shaping a voice reshapes *every* hit on it. You cannot
  have a light rimshot on beat 2 and a full snare on beat 4 out of one voice.
- **To get both in the same pattern, use a second voice of the same family** — kit-5 Hybrid ships two snares
  (indices 2 and 3); on any other kit a clap / perc / tom can be repurposed. Shape only that one and leave the
  main voice neutral.

**Worked example: rimshot / cross-stick on the snare.** Three knobs, all on the snare voice:

| Param | Direction | What it does |
| --- | --- | --- |
| `tune` | up | raises the pitch — the stick-on-the-rim crack, instead of the drum's body |
| `filter` | up | thins the tone out; the more you push it, the more hollow |
| `volume` (Level) | down | a lighter hit, so it sits behind the backbeat rather than in front of it |

All three together read as a light rimshot; nudge the three amounts until it sits right. The mapping is
monotonic, so the reverse is equally useful: **`tune` down makes the snare heavier and more powerful** — the
move for a big chorus backbeat or a heavier second half. The same logic transfers to every other voice: the
same three moves (pitch, filter, level) give any voice its own lighter and heavier variants, which is how you
carve out a kit's sound and how you keep two voices of the same family apart.

Say so in your delivery when you use this: these are the app's own Mixer controls, so the user can keep
adjusting by hand after import.

### 4.7 Three hard limitations

1. **The app only plays variation 1** (index 0). The data format supports 4, but writing variations 2
   through 4 produces no sound. Write variation 0 only.
2. **Do not use accent or chain.** The engine ignores them; they make no audible difference.
3. **Ratchets / flams are invisible in the app's UI** — only your ears can confirm them. Worth saying
   in your reply that "this step has two hits".

## 5. Musical quality floor

- **Make it listenable first**: kick and snare need a clear skeleton, hi-hats carry the groove. Do not
  fill every voice to the brim.
- **Leave space**: sparse usually beats dense; a trap kick should be sparse.
- **Vary**: when the user asks for 4 bars, do not write the same bar four times. But **do not casually
  delegate the fill to `apply_fill_mode`'s `lastBar`** — every fill mode is a whole-row replacement, and
  `lastBar` wipes every preceding bar along with it (see footguns item 10). The correct approach is to
  write the final bar yourself with `triggers`.
- **Swing comes from the groove parameter**; do not try to write swing into the grid — swing is a timing
  offset, not a positional one. `groove: ["swing", 0.35]` / `["shuffle", 0.6]`; `straight` is off.
- **Run `validate_draft` before shipping.** Shipping an empty PRESET is meaningless. But know its limits:
  `valid: true` **only guarantees the pattern is not empty overall** — it does not guarantee every bar has
  content. For multi-bar output you must check `grids` bar by bar yourself (see footguns item 10).

## 6. Delivery

`render_preset` returns **two links carrying the same payload**. Both are assembled server-side from one
encoded payload — your job is to hand them over whole, not to build either one:

| Field | What it is | When to lead with it |
| --- | --- | --- |
| `deeplink` | `drumai://import?p=<payload>` — opens the app's import panel directly, payload already filled in | The user is on a device with Drum AI installed |
| `url` | The `https://` landing page — rhythm preview, and from there "Open in App" / "Copy PRESET text" | The user is not on that device, or you do not know. It works everywhere |

Put each in **its own code block** so it is easy to copy, labeled as the app link and the web preview,
and explain the paths:

1. Tap the app link (`deeplink`) on the device → the app launches with the payload already loaded into the
   import panel; review it and tap Import. (Shortest path)
2. Or open the web link (`url`) → the "Open in App" button on the page does the same thing.
3. Neither button works (app not installed / browser blocked the scheme) → use "Copy PRESET text" on the
   page → go to the app's drum sequence page → PRESET menu → Import → paste.

**Never assemble the deep link yourself.** It is tempting to copy the `p` value out of `url` and prepend
`drumai://import?p=`; that is exactly the hand-transcription that drops characters, and it is unnecessary
because the server already returns the finished `deeplink`. Do not paraphrase the payload, do not truncate
either link, do not substitute "already generated", and do not write out a separate copy of the payload
text. The link *is* the payload.

### If the user comes back with a broken link

A user may return saying the link will not open, or paste back the error they saw. Handle it in this
order. Do not just apologise, and do not try to repair the old link.

1. **Find out what they saw.** If they only said "it doesn't work", ask them to open the link and press
   **"Copy error details"** on the page — it hands back the reason and the technical detail as one short
   block they can paste to you. It deliberately leaves the link itself out; you do not need it back.
2. **Read the cause.** That block carries the failure code and the payload length, which is enough to
   tell the two cases apart:
   - `payload_length_invalid` or `inflate_failed` — the payload text was damaged on the way: a
     character was dropped, or the string was cut short. This is the usual cause.
   - If they pasted the link itself instead, `parse_preset` confirms it and returns the same codes.
   - If the page renders fine for them, the link is intact and the problem is on their side: the app is
     not installed, or the browser blocked the `drumai://` scheme. Point them at "Copy PRESET text" on
     the page instead.
3. **Re-issue; do not patch.** Call `render_preset` again on the same draft and hand over the fresh
   `url` and `deeplink`. The pattern was never wrong, so a re-render always succeeds. If the draft is
   gone, rebuild it — never retype the damaged link, and never hand back the same one "to try again".
4. **Say plainly what happened:** the link text was damaged in transit, here are new ones, tap the app
   link (or open the web link and tap "Open in App"). Put each new link in a code block by itself, with
   nothing else on those lines.

## 7. Tool quick reference

| Tool | What it does |
| --- | --- |
| `list_kits` / `get_kit` | The 24 kits / one kit's voice table (**must call before writing a pattern**) |
| `list_grid_options` | Time signature × density → step structure and position names |
| `list_fill_modes` | The 20 fill modes (single row) |
| `list_style_templates` | The 8 style skeletons (whole ensemble, mapped by role) |
| `list_reference_presets` / `get_reference_preset` | Overview of the 50 built-in PRESETs / full grid |
| `create_draft` | Create a draft (optionally starting from a built-in PRESET via `fromPresetId`; tag its style with `tags`) |
| `set_voice_grid` | **Write the pattern (most used)**; supports `mode:"append"` to layer |
| `apply_fill_mode` / `apply_style_template` | Apply a fill mode / a style skeleton |
| `update_draft` | Change transport, voice parameters, master chain, `tags`, variation copy and clear |
| `get_draft` / `validate_draft` / `list_drafts` / `delete_draft` | Read back / validate / list / delete |
| `render_preset` | **Produce the two links** — `url` (landing page) + `deeplink` (`drumai://`) — optionally with `preview` and `diagnostics` |
| `parse_preset` | Parse DHP2 share text / a DHP3 payload / a full link → editable `spec` |
| `render_wireframe` | Same input, read-only: draw it as a wireframe score so you or the user can see the pattern |

Full parameters, return values, and error codes for every tool are in `references/tools.md`.
Writing traps that are known to produce wrong patterns are in `references/footguns.md` — worth a scan
before you start.

## 8. Reference files

- `references/tools.md` — parameters, returns, and error semantics for the 19 tools
- `references/footguns.md` — the writing-trap list (each entry gives the correct form)
- `references/channels.md` — how to reach the service over each of the three channels, plus protocol details
- `references/setup.md` — for humans: requirements, installing the skill, configuration, the script channel and
  its exit codes, self-hosting, and troubleshooting
- `references/recipes.md` — end-to-end recipes (house / boom bap / trap / multi-bar from a built-in PRESET)
  with the actually-run call sequences
- `references/samples.md` — decoded real exports drawn as wireframe scores, starting with the
  `cellsPerQuarter: 8` double-bass sample; also documents how to read a wireframe score. That format is
  exactly what `render_wireframe` returns in `score`
- `scripts/call.sh` — the JSON-RPC call script for non-MCP clients
- `README.md` — for humans: what Drum AI is, how to download it, how to install this skill, and a FAQ
  (not needed by the AI); the technical half of it lives in `references/setup.md`
- `.mcp.json` / `.claude-plugin/plugin.json` — the MCP service declaration; configuration details live there, not here
- `.env.example` — environment variable template; copy it to `.env` to use
