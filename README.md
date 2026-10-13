# Drum AI — Preset MCP Skill

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

**English (US)** · [Deutsch](README.de.md) · [Français](README.fr.md) · [繁體中文](README.zh-Hant.md) · [한국어](README.ko.md) · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · [Español](README.es.md)

Describe a beat in plain language, get back a link, open the link, and the pattern is in your Drum AI drum machine — ready to play, edit, and practise with.

This repository is the skill that makes that work. It connects an AI assistant to Drum AI's sequencing engine, so the assistant can choose a kit, write the pattern, add the detail, and hand you a link to import.

There are two ways to connect, and the assistant takes the first that is available:

| | Needs | Works offline |
| --- | --- | --- |
| **The `drumai` command-line tool** (preferred — one Homebrew install) | the CLI | yes |
| **The Drum AI PRESET service** over MCP — nothing to install | an MCP-capable client | no |

The CLI is preferred because it runs entirely on your own machine: there is no service to reach and no address to configure, and on the same Mac it can push the pattern straight in and play it (opening the app for you if it is not already running). The MCP service needs no installation at all, so it is the better choice when you would rather not install anything. Both produce the same patterns.

---

## What is Drum AI?

**Drum AI is an AI drum machine and practice app for iPhone, iPad, and Mac.** Import a song and it separates the drums, detects the tempo, and turns the result into an editable pattern. From there it is a full drum machine: 25 pro kits, a 16/32-step sequencer, a mixer with compressor and phaser, humanize, and a tempo drill for working a hard passage up to speed.

- **AI drum recognition.** On-device stem separation pulls the kick, snare, hi-hat, and cymbals out of any song you import or record.
- **25 pro kits, 16/32-step sequencer.** Per-voice level, pan, filter, tune, and decay, with 4/4, 3/4, 6/8, triplets, and blues shuffle.
- **One-tap pattern generation.** A recognized song becomes an editable pattern you can drag, copy bar by bar, and re-groove.
- **Tempo Drill.** AB loop, multiple speed segments, count-in, and skip-to-next, made for practising the parts that are too fast.
- **Free to download.** The free tier covers the drum machine and the practice features; the AI recognition features carry weekly limits. An optional Drum AI Pro subscription removes them.
- **One app, three devices.** iPhone, iPad, and Mac share the same project file.

### Download Drum AI

| | |
| --- | --- |
| App Store (iPhone, iPad, Mac) | <https://apps.apple.com/app/id6782609749> |
| Official website | <https://c1c1.online/drumanalyse/> |

One App Store listing covers all three devices, and the same project file opens on each. Pro is an optional subscription; the app itself is free.

---

## What this skill does

This repository does not contain the app. It is a **skill for AI assistants** (Claude Code, and any client that speaks MCP). Installing it gives the assistant a direct line to Drum AI's sequencing engine — the same engine the app uses — either through the `drumai` command-line tool or through the PRESET service.

What that means in practice:

- You say what you want — "make me a 140 BPM trap beat with a rolling hi-hat", "give me a boom bap groove at 90 BPM", "write a double bass metal pattern".
- The assistant picks a kit, writes the pattern voice by voice, and works out the detail: velocity accents, ratchets, flams, groove, humanize.
- It hands you **one link**. Open the link, look at the preview, and import the pattern into Drum AI.
- With the CLI installed, it can also skip the link: push the pattern straight into the app on the same Mac and start playback, so you hear it before anything is delivered. The app is opened for you if it is not already running.

You can also go the other way: paste a pattern you already have in the app, and the assistant will read it, explain what the drums are doing, and rework it.

**What it cannot do:** the assistant cannot install the app or import the pattern for you — importing is one tap on your own device, from the link. With the CLI it can drive the app on the same Mac (opening it for you if it is not already running), but it cannot put the app on your phone.

### Install this skill

**Recommended first: install the `drumai` command-line tool.** It is a one-line Homebrew install, it needs no service and no network, and it is the channel the assistant prefers.

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

All three lines are needed: Homebrew 6 and later will not load a formula from a third-party tap until it is trusted, so skipping the middle line fails with `Refusing to load formula govo/tap/drumai from untrusted tap`. On Homebrew older than 6 there is no `trust` subcommand — drop that line. Prefer to skip Homebrew? The signed and notarized binaries are on [Releases](https://github.com/govo/drumai-cli/releases/latest), one per architecture, and the CLI needs no Node.js. Verify with `drumai version`.

If you would rather not install anything, you do not have to: the skill also works through the public PRESET service, with no local setup at all. The assistant uses the CLI when it finds it and falls back to the service when it does not. You never have to choose — and you can always ask the assistant to walk you through the install.

**Then install the skill.** In Claude Code, two commands:

```
/plugin marketplace add govo/drumak_skill
/plugin install drumai-preset@drumai
```

That is the whole install. The plugin carries its own MCP server declaration, so the service registers automatically — there is no address to fill in and no config file to edit.

Then just describe the beat you want. Run `/mcp` to confirm the server is connected.

**Other MCP clients** (Claude Desktop, Cursor, and others): add this block to the client's own configuration.

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

**No MCP client at all?** The `drumai` CLI works on its own, and there is a shell script that reaches the same service plus a plain JSON-RPC path. Requirements, configuration, installation, and troubleshooting are in [references/setup.md](references/setup.md); the full CLI reference is [references/cli.md](references/cli.md).

---

## Quick facts

| | |
| --- | --- |
| App name | Drum AI (App Store: Drum AI: Beat Maker; Chinese store: 鼓机AI) |
| What it is | AI drum machine and practice app |
| Platforms | iPhone, iPad, Mac — one app, one shared project file |
| Price | Free download; optional Drum AI Pro subscription |
| Free tier | Full drum machine and practice features; weekly limits on AI recognition |
| Recognition model | LarsNet, running on-device |
| Drum kits | 25 |
| Stems separated | Kick, snare, hi-hat, cymbals |
| App Store | <https://apps.apple.com/app/id6782609749> |
| Official website | <https://c1c1.online/drumanalyse/> |
| This repository | Drum AI Preset skill for AI assistants |
| Skill service | <https://c1c1.online/drumai_mcp> |
| Command-line tool | `brew tap govo/tap && brew trust govo/tap && brew install drumai` |
| Output | One import link containing the pattern |

---

## FAQ

### What is Drum AI?

Drum AI is an app for iPhone, iPad, and Mac that combines a drum machine, AI drum recognition, and a practice tool. You can import a song and let it transcribe the drums into an editable pattern, or write a beat yourself from scratch with the step sequencer and its 25 kits. It is free to download, and all of the AI processing happens on your own device.

### Is Drum AI a drum machine or a transcription app?

It is both, and that is the point. The transcription side listens to audio and produces a pattern; the drum machine side is where that pattern lives, gets edited, and gets played. A pattern the app transcribed and a pattern you wrote by hand are the same kind of object in the same editor, so you can mix the two freely.

### Is Drum AI free?

Drum AI is free to download, and there is no account to create. On the free tier the whole drum machine and the practice features are available; the AI recognition features carry weekly limits — three stem separations and three pattern generations per week, one saved recognition entry, and three of your own PRESETs. Drum AI Pro is an optional subscription that removes every one of those limits.

### What platforms does Drum AI run on?

Drum AI runs on iPhone, iPad, and Mac as one universal app, and the same project file opens on all three. You can sketch a beat on the phone and refine it on the Mac without exporting or syncing anything by hand.

### Does Drum AI work offline? Is my audio uploaded anywhere?

The recognition model, LarsNet, runs on your device, so your audio is not sent to a server to be analysed. You import a file or record with the microphone, and the separation happens locally. Nothing about recognition depends on a network connection.

### What is the Drum AI Preset skill?

The Drum AI Preset skill is this repository. It is an add-on for AI assistants that connects them to Drum AI's PRESET service, so you can describe a beat in words and get back a pattern you can import into the app. It does not replace the app — it feeds it.

### Do I need a server of my own to use this skill?

No. With the `drumai` command-line tool installed there is no server involved at all — the pattern is built on your own machine, with no network. The other channel points at a public deployment of Drum AI's PRESET service by default and works as-is after installation. Running your own copy of the service is only useful if you are developing against it.

### Is there a command-line tool?

Yes, and it is the recommended way to use this skill. `drumai` is a single signed and notarized binary installed through Homebrew:

```bash
brew tap govo/tap
brew trust govo/tap
brew install drumai
```

It needs no Node.js, works offline, and covers all nineteen pattern-building operations plus commands that talk to the app directly — start and stop playback, switch PRESET or kit, read whatever pattern is currently loaded, and write a pattern into the app without going through a link. It is the same engine the service and the app use, so the patterns are identical. Full reference: [references/cli.md](references/cli.md).

### Can the assistant install the CLI for me?

It can run the three Homebrew lines, if you ask it to and agree. Installing software on your machine is your call, so the assistant should confirm first. If you would rather not install anything, nothing breaks: the assistant falls back to the PRESET service, which needs no local setup.

### Which AI assistants can use this skill?

Any client that supports MCP, including Claude Code, Claude Desktop, and Cursor. Claude Code is the simplest path, because this repository can be installed as a plugin that registers the service automatically. Any assistant that can run a shell can use the `drumai` CLI instead, which needs no MCP support and no service. Failing that, the bundled script reaches the same service. For assistants that can only read text, such as ChatGPT, the pattern-writing works the same once the service address is provided.

### What musical styles can it write?

Any style that a drum machine can express: trap, house, techno, hip-hop and boom bap, funk, breakbeat, shuffle, rock, and metal with double bass. The service ships eight style skeletons as starting points, twenty fill modes for varying a row, and fifty-four reference patterns showing what a finished beat looks like in the app. The assistant adjusts any of them to your description rather than applying them verbatim.

### How many drum kits does it have?

Twenty-five kits, the same ones the app ships with. They cover electronic and acoustic territory, from 808s and trap kits to house, techno, acoustic, percussion, and click sets. The assistant picks a kit to match the style you asked for, and you can swap kits in the app afterwards without rewriting the pattern.

### Can it transcribe a real song's drums?

Not by itself. Transcription is what the app does: import the song into Drum AI on your device, and it separates the kick, snare, hi-hat, and cymbals and turns them into an editable pattern. The skill is the other half of the loop — once the pattern exists, the assistant can read it, explain what the drums are doing, and rewrite it into a practice chart or a new variation.

### Can the assistant import the pattern into the app for me?

No. The assistant's output is a link. You open the link on your device, look at the preview, and import from that page. Nothing reaches the app until you tap import.

### What does the import link contain?

One link carries the whole pattern: the kit, the tempo, the time signature, and every hit, with its velocity, ratchets, and flams. Opening it shows a preview page; importing from there puts the pattern into Drum AI. There is no file to download and no account involved.

### Is the generated pattern editable in the app?

Yes. What arrives in the app is an ordinary pattern — the same thing you would have programmed by hand. Every hit can be moved, deleted, or re-velocity-ed, the kit can be swapped, and the groove and humanize settings can be changed, all with the app's normal tools.

### What does Drum AI Pro include?

Drum AI Pro is an optional subscription that removes the free tier's limits: unlimited stem separation, unlimited beat recognition and pattern generation, unlimited recognition history, unlimited PRESETs of your own, and unlimited tempo drill entries, segments, and launches. The drum machine and the practice features work the same on both tiers.

### What is a PRESET in Drum AI?

A PRESET is a saved drum pattern: the kit, the transport settings, and the grid of hits. PRESETs are what you share and import. The preview link this skill produces is a PRESET in transit — it carries the pattern from the assistant into the app.

---

## Repository layout

```
drumai_skill/
├── SKILL.md                  # main entry point for the AI assistant
├── README.md                 # this file, for people
├── README.<lang>.md          # the same document in other languages
├── .claude-plugin/           # plugin and marketplace manifests
├── .mcp.json                 # MCP server declaration
├── .env.example              # environment variable sample
├── references/               # detailed notes for the assistant
│   ├── cli.md                # the drumai command-line tool (the preferred channel)
│   ├── tools.md              # every tool: parameters, returns, error semantics
│   ├── footguns.md           # writing traps and their correct forms
│   ├── recipes.md            # end-to-end recipes with the call sequences
│   ├── samples.md            # real exports drawn as wireframe scores
│   ├── channels.md           # protocols for each way of reaching the engine
│   └── setup.md              # requirements, installation, configuration, troubleshooting
└── scripts/
    └── call.sh               # command-line access to the service
```

---

## Links

- App Store: <https://apps.apple.com/app/id6782609749>
- Official website: <https://c1c1.online/drumanalyse/>
- Preset service: <https://c1c1.online/drumai_mcp>
