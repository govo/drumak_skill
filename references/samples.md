# Sample Library

Real exports, decoded and reduced to a wireframe score. Use them as a reference for what a pattern
that already works in this app actually looks like: the shape, the density, how the sound detail is
spread out.

Two things to keep in mind when you take a grid out of here:

- A grid belongs to the kit it was exported from. Re-map the **roles** against the kit you actually
  picked with `get_kit`; index numbers usually do not carry over.
- Feed a grid to `set_voice_grid` as the `triggers` string. The wireframe below is drawn with bar and
  beat separators so a human or a model can read it; **the separators are not part of the string**.
  Delete them and what is left is exactly `bars × stepsPerBar` characters of `x` and `-`.
- This is the same format the **`render_wireframe`** tool returns in its `score` field, so any pasted
  `DHP2;...` blob — or a payload of your own — can be drawn in this shape on demand.

## How to read a wireframe score

```
        B1      :        :        :        |B2      :        :        :
        1       :2       :3       :4       |1       :2       :3       :4
        --------:--------:--------:--------+--------:--------:--------:--------
Kick    xxxxxx--:--------:xxxxxx--:--------|xxxxxx--:--------:xxxxxx--:--------
        ^cell 0                          ^cell 32 = bar 2 starts here
```

- One character per cell (`step`): `x` triggers, `-` silent.
- `|` is a bar line, `:` a beat line, `+` a bar line inside the separator row. Each of these is **one
  extra column inserted between two cells** — a reading aid, not a cell.
- The ruler rows and the voice rows are laid out cell for cell, so a column lines up exactly.
- Only the voices that actually carry notes are drawn; the silent ones are named under the score.

The line above therefore reads back as the 64-character string
`xxxxxx----------xxxxxx----------xxxxxx----------xxxxxx----------`.

---

## Sample 1: Metallica "One" double bass (8 cells per beat)

### Source

A user export, decoded with zero bytes left over: `DHP2;k=kit-12;b=106;n=KiBNZXRhbGxpY2Egb25l`,
8 voices, 64 steps.

| | |
| --- | --- |
| kit | `kit-12` (Acoustic) |
| bpm | 106 |
| ts / groove / humanize | 4/4, `straight`, 0 |
| `cellsPerQuarter` | **8** — one cell is a thirty-second note, so **8 cells per beat, 32 steps per bar** |
| bars | 2, and the two are not identical — bar 2 adds a snare hit and brings in the crash |
| sound detail | every velocity is 1, no ratchets, no flams, every timing nudge 0 — the interest is entirely in the grid |

### Score

```
        B1      :        :        :        |B2      :        :        :
        1       :2       :3       :4       |1       :2       :3       :4
        --------:--------:--------:--------+--------:--------:--------:--------
Kick    xxxxxx--:--------:xxxxxx--:--------|xxxxxx--:--------:xxxxxx--:--------
Snare   --------:x-------:--------:x-------|--------:x---x---:--------:x-------
OHat    x-------:x-------:x-------:x-------|x-------:--------:x-------:x-------
Crash   --------:--------:--------:--------|--------:x---x---:--------:--------
```

Silent voices: HiTom (1), LoTom (3), Hat (4), Ride (6).

### What the pattern actually is

**Kick (index 0), 24 hits — this is the double bass.** Beats 1 and 3 of every bar carry a burst of
**six consecutive thirty-second notes**, then the voice rests for the remaining 1.25 beats; the figure
repeats every two beats. At 106 BPM one cell is 70.8 ms, so the burst is six hits 70.8 ms apart
(about 14 hits per second) followed by a 778 ms gap.

The point of the 8-cell grid is exactly this: six thirty-seconds do not fit inside the four steps that
one beat has on a sixteenth-note grid, so at that density the figure is not available at all — the
closest you could write is six sixteenths spanning 1.5 beats, which is a rhythm twice as slow. Doubling
the density is what makes the burst possible. See SKILL.md section 4.4.

**Snare (index 2), 5 hits.** Bar 1 is a plain backbeat, beats 2 and 4. Bar 2 keeps beat 2 and beat 4
and adds a hit on the **"and" of beat 2** (cell 44, i.e. 4 cells after beat 2 = half a beat).

**OHat (index 5), 7 hits.** Bar 1 on every beat. Bar 2 on beats 1, 3 and 4 — beat 2 is left to the
crash.

**Crash (index 7), 2 hits,** both in bar 2 and both landing exactly on the snare hits (cells 40 and
44). Bar 2 is a two-bar phrase's turnaround: the open hat drops out, the crash comes in, and the
snare adds the "and".

### Reproducing it

```
1) create_draft
   {"kit":"kit-12","name":"One double bass","bpm":106,
    "cellsPerQuarter":8,"bars":2,"groove":["straight",0],"humanize":0}

2) set_voice_grid        # 2 bars x 32 steps = 64 characters per row
   {"draftId":"...","voices":[
     {"index":0,"triggers":"xxxxxx----------xxxxxx----------xxxxxx----------xxxxxx----------"},
     {"index":2,"triggers":"--------x---------------x---------------x---x-----------x-------"},
     {"index":5,"triggers":"x-------x-------x-------x-------x---------------x-------x-------"},
     {"index":7,"triggers":"----------------------------------------x---x-------------------"}]}

3) validate_draft {"draftId":"..."}
4) render_preset  {"draftId":"...","include":["url"]}
```

Notes:

- Write all four rows in **one** `set_voice_grid` call; the rows that stay silent are simply not
  mentioned.
- These are `triggers`, so bar 2 differing from bar 1 costs nothing — that is the whole reason to use
  `triggers` here instead of `hits`, which would repeat bar 1's figure into bar 2 and lose the crash.
- Round-tripping the export through `parse_preset` shows `bars: 2` inferred from the 64 steps; the
  wire format has no bar count, so that number is a derivation, not a stored value.
- **The master chain does not survive a rebuild.** The export carries
  `filter 50 / saturation 0 / phaser 0 / reverb 0 / compThreshold 75 / compRatio 16 / compAttack 74 /
  compRelease 59 / compGain 0 / compMix 70 / masterVolume 100`. `create_draft` has no `master`
  parameter, so a rebuilt draft starts from the engine default; write the chain afterwards with
  `update_draft` if the user wants the same tone (and note it cannot be read back — tools.md item 12).
- **Density costs size.** 8 voices at 64 steps is a 2510-byte payload, 3347 characters of base64url.
  The same 8 voices over 32 steps — the same two bars on a sixteenth grid — is 1390 bytes and 1854
  characters, so halving the step count nearly halves the share text. The DHP2 share text caps at
  16384 characters, and `render_preset` starts warning (`dhp2_step_limit_exceeded`) above about 330
  steps, which at 32 steps per bar is about 10 bars. Both are warnings about the old format, not about
  what you produced — see footguns item 16.
