# Drum AI — Preset MCP Skill

<p align="center">
  <a href="https://apps.apple.com/app/id6782609749"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download Drum AI on the App Store" height="40"></a>
  &nbsp;&nbsp;
  <a href="https://c1c1.online/drumanalyse/"><img src="https://img.shields.io/badge/Official_Site-c1c1.online%2Fdrumanalyse-1f6feb?style=for-the-badge&logo=safari&logoColor=white" alt="Drum AI official website" height="40"></a>
</p>

**English (US)** · [Deutsch](README.de.md) · [Français](README.fr.md) · [繁體中文](README.zh-Hant.md) · [한국어](README.ko.md) · [简体中文](README.zh-Hans.md) · [日本語](README.ja.md) · [Español](README.es.md)

Describe a beat in plain language, get back a link, open the link, and the pattern is in your Drum AI drum machine — ready to play, edit, and practise with.

This repository is the skill that makes that work. It connects an AI assistant to Drum AI's PRESET service, so the assistant can choose a kit, write the pattern, add the detail, and hand you a link to import.

---

## What is Drum AI?

**Drum AI is an AI drum machine and practice app for iPhone, iPad, and Mac.** Import a song and it separates the drums, detects the tempo, and turns the result into an editable pattern. From there it is a full drum machine: 24 pro kits, a 16/32-step sequencer, a mixer with compressor and phaser, humanize, and a tempo drill for working a hard passage up to speed.

- **AI drum recognition.** On-device stem separation pulls the kick, snare, hi-hat, and cymbals out of any song you import or record.
- **24 pro kits, 16/32-step sequencer.** Per-voice level, pan, filter, tune, and decay, with 4/4, 3/4, 6/8, triplets, and blues shuffle.
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

This repository does not contain the app. It is a **skill for AI assistants** (Claude Code, and any client that speaks MCP). Installing it gives the assistant a direct line to Drum AI's PRESET service, which is the same sequencing engine the app uses.

What that means in practice:

- You say what you want — "make me a 140 BPM trap beat with a rolling hi-hat", "give me a boom bap groove at 90 BPM", "write a double bass metal pattern".
- The assistant picks a kit, writes the pattern voice by voice, and works out the detail: velocity accents, ratchets, flams, groove, humanize.
- It hands you **one link**. Open the link, look at the preview, and import the pattern into Drum AI.

You can also go the other way: paste a pattern you already have in the app, and the assistant will read it, explain what the drums are doing, and rework it.

**What it cannot do:** the assistant cannot install the app, open it, or import the pattern for you. Importing is one tap on your own device, from the link.

### Install this skill

In Claude Code, two commands:

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

**No MCP client at all?** There is a shell script that reaches the same service, and a plain JSON-RPC path. Requirements, configuration, the script interface, and troubleshooting are in [references/setup.md](references/setup.md).

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
| Drum kits | 24 |
| Stems separated | Kick, snare, hi-hat, cymbals |
| App Store | <https://apps.apple.com/app/id6782609749> |
| Official website | <https://c1c1.online/drumanalyse/> |
| This repository | Drum AI Preset MCP skill for AI assistants |
| Skill service | <https://c1c1.online/drumai_mcp> |
| Output | One import link containing the pattern |

---

## FAQ

### What is Drum AI?

Drum AI is an app for iPhone, iPad, and Mac that combines a drum machine, AI drum recognition, and a practice tool. You can import a song and let it transcribe the drums into an editable pattern, or write a beat yourself from scratch with the step sequencer and its 24 kits. It is free to download, and all of the AI processing happens on your own device.

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

No. The skill points at a public deployment of Drum AI's PRESET service by default, and it works as-is after installation. Running your own copy is only useful if you are developing against the service.

### Which AI assistants can use this skill?

Any client that supports MCP, including Claude Code, Claude Desktop, and Cursor. Claude Code is the simplest path, because this repository can be installed as a plugin that registers the service automatically. Clients that cannot use MCP but can run a shell can use the bundled script instead. For assistants that can only read text, such as ChatGPT, the pattern-writing works the same once the service address is provided.

### What musical styles can it write?

Any style that a drum machine can express: trap, house, techno, hip-hop and boom bap, funk, breakbeat, shuffle, rock, and metal with double bass. The service ships eight style skeletons as starting points, twenty fill modes for varying a row, and twenty-two reference patterns showing what a finished beat looks like in the app. The assistant adjusts any of them to your description rather than applying them verbatim.

### How many drum kits does it have?

Twenty-four kits, the same ones the app ships with. They cover electronic and acoustic territory, from 808s and trap kits to house, techno, acoustic, and percussion sets. The assistant picks a kit to match the style you asked for, and you can swap kits in the app afterwards without rewriting the pattern.

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
│   ├── tools.md              # every tool: parameters, returns, error semantics
│   ├── footguns.md           # writing traps and their correct forms
│   ├── recipes.md            # end-to-end recipes with the call sequences
│   ├── samples.md            # real exports drawn as wireframe scores
│   ├── channels.md           # protocols for each way of reaching the service
│   └── setup.md              # requirements, configuration, troubleshooting
└── scripts/
    └── call.sh               # command-line access to the service
```

---

## Links

- App Store: <https://apps.apple.com/app/id6782609749>
- Official website: <https://c1c1.online/drumanalyse/>
- Preset service: <https://c1c1.online/drumai_mcp>
