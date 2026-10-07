# Footgun Checklist

These are all cases where the parameters you write are perfectly legal and raise no error at all, yet the pattern produced is not the one you wanted.
Each entry gives **wrong way → consequence → right way**. Skim this before you start writing.

---

## 1. `hits` writes into every bar separately (the easiest one to trip on)

```
{"index": 0, "hits": [{"beat": 3, "offset": "and"}]}      // the draft has 4 bars
```

**Consequence**: one note is written in each of the 4 bars, 4 in total. There is **no way at all for `hits` to target a single bar**.
It also accepts a "cross-bar" step index, but that gets taken modulo the bar and repeated as well:
with 2 bars of 16 steps each, `{"step": 20}` raises no error, lands on step 4 inside the bar, and puts one note in each of the two bars.

**Right way**:

| Goal | How |
| --- | --- |
| Same in every bar | Either `hits` or `triggers` works |
| Different per bar (fills, variation) | Only `triggers` works: write exactly `bars × stepsPerBar` characters, one segment per bar concatenated |

```
{"index": 0, "triggers": "x---x---x---x---x---x---x---x---x---x---x---x---x---x---x-x-x-x-"}
//                         bar 1           bar 2           bar 3           bar 4 (varies)
```

When you need a "fill in the last bar", **do not** hand the whole row straight to `apply_fill_mode` — it empties the earlier bars along with it,
see item 10.

---

## 2. Two counting bases in one request: `beat` is 1-based, `step` and `velocities` are 0-based

| Field | Base |
| --- | --- |
| `hits[].beat` | **1-based** (write `1` for the 1st beat) |
| `hits[].step` | **0-based** (write `0` for the 1st step) |
| keys of `velocities` | **0-based** (as strings, not numbers) |
| `variation` | **0-based** (when the docs say "the 1st variation" they mean index 0) |

**Consequence**: `{"beat": 1}` and `{"step": 0}` mean the same position (in a 4/4 sixteenth grid both are the first beat of the bar),
but swapping one for the other shifts everything by one step, **and both values are legal, so no validation will stop you**.

**Right way**: when you are unsure, use `beat` + `offset` throughout; when you do write `velocities`, key it with the
0-based index of the same position, and say to yourself once "this one is 0-based".

**The escape hatch**: putting `velocity` on the hit itself (`{"beat": 2, "offset": "a", "velocity": 0.4}`) keeps
everything in the 1-based world — there is no index to convert and none to get wrong. Reach for that whenever you
wrote the triggers with `hits`.

---

## 3. `fromPresetId` overwrites your inputs, `bars` is forced to 1, and it **copies only the grid**

```
{"kit":"kit-4","name":"MyName","bpm":200,"bars":4,"cellsPerQuarter":8,
 "fromPresetId":"preset-slime-time"}
```

**Consequence** (measured): `kit` becomes `kit-10`, `name` and `bpm` come from the PRESET, `cellsPerQuarter` becomes 4,
**`bars` becomes 1**. The 4 bars, density 8 and `MyName` you passed are all thrown away, with no error.

**What it copies and what it does not** (this is the thing most easily overestimated):

| | |
| --- | --- |
| Copies | kit, name (taken from the PRESET; what you passed is void), BPM, time signature, grid density, swing (converted as `swing/100`), trigger grid |
| **Does not copy** | **velocities, ratchets, flams, master chain (`master`)** |

The reason is that the built-in PRESET reference library on the MCP side **has only the trigger grid** (the
`grids` returned by `get_reference_preset` are all there is). The factory PRESET in the App does have velocities and a master chain,
but that information never entered the reference library, so "starting from a built-in PRESET" actually gives you the
**skeleton only, all velocities at 1, master chain all at default** version.
To restore the factory sound you have to supply `velocities` and the `master` of `update_draft` yourself —
but before you do, read the caution about master parameters in item 11, and confirm with the user.

**Going multi-bar: the two-step approach is not enough either, you must rewrite the grid yourself.**

```
1. create_draft({ kit, name, bpm, fromPresetId })       // all three required, values get overwritten by the PRESET
2. update_draft({ draftId, transport: { bars: 4 } })   // only gives warning grid_resized
3. set_voice_grid voice by voice, using triggers to repeat the content of bar 1
   bar by bar into bars × stepsPerBar characters            // skip this step and bars 2..4 are all silent
```

After step 2, **bars 2 through 4 are completely empty** (rebuilt left-aligned, padded with `-`), and
`validate_draft` gives `valid: true` for that result — it only judges "the whole thing is not empty", so it cannot stop this.
`hits` cannot save you either (it repeats in every bar and cannot write one single bar), **only `triggers` can write a per-bar grid**.

**Two side notes**: a draft created with `fromPresetId` **cannot be renamed** (`name` is overwritten by the PRESET,
and `update_draft` has no `name` field), so after the user imports it the library gains one more PRESET with the same name. For an independent name,
the only option is to take the grid from `get_reference_preset` and rebuild it by hand with `kit` / `bpm` / `groove`.

**Also**: on this path you will see a warning with `code: "kit_changed"`, whose content is the swing unit conversion,
**unrelated to changing kits** — that is the code being misused; ignore it, the kit was not changed.

---

## 4. A short grid raises no error, it is silently padded with `-`

```
{"index": 0, "triggers": "x---x---"}      // target 16 steps
```

**Consequence**: you only get the warning `grid_padded`, 8 `-` are appended on the right, and the second half of the bar is silent.
Writing a 1-bar string when you meant 4 bars gives exactly this result — it sounds like "only one bar played".

**Right way**: before writing a grid, confirm `stepCount` (`list_grid_options`, or `derived.stepCount` from
`create_draft`), or just check the `grids` returned by `set_voice_grid`.
A `ratchets` / `flams` grid that is too short **does not even give a warning**, so count it yourself even more carefully.

---

## 5. The "beat" in a fill mode name is not the beat of the time signature

Names such as `fourOnFloor` (four on the floor) and `eighth` (eighth note) in `apply_fill_mode`
internally use `floor(stepsPerBar / 4)` — they **split a bar into four equal parts**, rather than actually taking beats from the time signature.

**Consequence** (this is existing behavior shared by the App and the MCP, not a bug in this service):

| Time signature (sixteenth grid) | Steps | Actual `eighth` result | Expected |
| --- | --- | --- | --- |
| 4/4 | 16 | `x-x-x-x-x-x-x-x-` (8 hits) | Correct |
| 3/4 | 12 | `xxxxxxxxxxxx` (12 hits) | Should be one hit every 2 steps |
| 6/8 | 12 | `xxxxxxxxxxxx` (12 hits) | Wrong |
| 5/4 | 20 | `x-x-x-x-x-x-x-x-x-x-` (10 hits) | Correct |

Under 4/4 the name happens to match the real behavior, so this trap is only exposed in non-4/4 time signatures.

**Right way**:

- Under a non-4/4 time signature, **do not infer the result from the fill mode name**.
- These modes accept only one target voice, produce a whole-row grid, and **return the grid they actually generated** —
  read the returned `grids` after calling; if it is wrong, switch to writing it by hand with `set_voice_grid`.

---

## 6. `triplet2` / `triplet3` in `offsets` do not mean triplets

`list_grid_options` returns `offsets: ["downbeat","triplet2","triplet3"]` at "3 cells per beat".
The names come from the "cell count", not from musical meaning.

Under a 6/8 time signature those three cells are **three eighth notes** (compound meter, one beat = dotted quarter), not a triplet.

**Right way**: use `offsets` only as "the name of which cell it is". To know what note that is, look at
the three fields `isTriplet` / `isCompound` / `stepsPerBeat`, not at the name.

**If you want real triplets**: set `cellsPerQuarter: 3` (eighth-note triplets, 12 steps per bar under 4/4)
or `6` (sixteenth-note triplets, 24 steps per bar). Triplets mean **changing the grid density**, not adding a marker.

---

## 7. `cellsPerQuarter` is not "how many cells per beat"

It is **how many cells one quarter note is divided into**, independent of the time signature.

**Consequence**: with 6/8 + `cellsPerQuarter: 2` there are 6 steps per bar and 3 cells per beat;
the intuition of "2 cells per beat" will make you think 6 steps per bar is 3 beats.

**Right way**: for anything involving "how many cells per beat / how many steps per bar / what a position is called", **look it up in `list_grid_options`**,
do not derive it yourself. The two are equal only under an x/4 time signature.

---

## 8. A ratchet is "half a cell", a flam is a fixed 18 milliseconds

- The extra hit of `ratchets` lands at **the halfway point of that step** (`ticksPerStep / 2`, i.e. half a cell).
  Under 4/4 + `cellsPerQuarter: 8`, one cell is 1/8 of a beat and half a cell is only 1/16 of a beat — on a dense grid a ratchet
  sounds very tight, so do not picture it as "the second half of the beat".
- The extra hit of `flams` is always **18 milliseconds** early and does not change with BPM.
  At 81 BPM it is only 5% of one cell (almost inaudible); on a thirty-second-note grid at 174 BPM it is 42% of one cell (very obvious).

**Right way**: use both of these by **controlling the quantity** — two or three ratchets in one hi-hat row is a roll,
filling it up just turns to mush. After generating, state in one sentence "which steps have two hits", because the App UI cannot show this information.

---

## 9. Only the 1st variation makes sound

The data format supports 4 variations, but **the current App only plays the one at index 0**.
Writing variation 1..3 gives the warning `variations_beyond_first_ignored` and **makes no sound**.

**Right way**: by default write only `variation: 0` (that is, do not pass `variation`).
For "multiple sections of variation", use **multiple bars + per-bar `triggers`**, or add fills with `apply_fill_mode`.

---

## 10. `apply_fill_mode` is a whole-row replacement that clears velocities; `update_draft` rebuilds the grid when you change structure

- **Every fill mode is a "whole-row replacement"**, not "stacked on top of the existing triggers". Among them `lastBar` generates a
  grid where **only the last bar has content** — every earlier bar is cleared to `-` (measured; true for seeds 1..42).
  Which is to say: layering a `lastBar` fill onto an already written 4-bar melody **silences the first 3 bars**,
  and what the user hears is "the whole beat is gone, only the last bar is playing".
  **No fill mode can express "keep the first N-1 bars, change only the last bar".**
  To add a fill in the last bar while keeping the earlier ones, you can only write the last bar yourself with `triggers`, or copy the original grid
  down first, apply `lastBar`, then write the first N-1 bars back.
- While `apply_fill_mode` writes `triggers` it **discards that row's `velocities` (velocities go back to 1)**;
  `ratchets` / `flams` are kept. So **add fills first, then do the velocity layering** — reverse the order and the velocities are gone.
- `update_draft` changing `bars` / `ts` / `cellsPerQuarter`: **rebuilds all grids** (left-aligned,
  extra truncated, shortfall padded with `-`, out-of-range `velocities` keys deleted), with the warning `grid_resized`.
  This is not a lossless operation — **finish changing structure before writing the drum pattern**, do not write first and change after.
  When you increase the step count **the newly added bars are empty** and will not automatically copy the content of bar 1. And `validate_draft`
  still returns `valid: true` for a 4-bar draft where "only bar 1 has content" — **`valid` does not mean every bar has content**,
  so for multi-bar output you must slice `grids` yourself and check bar by bar.
- `update_draft` changing `kit`: the grid is kept, but **the meaning of every index changes** (warning `kit_changed`).
  A note originally written on index 1 may turn from "the second kick" into "the bass". After switching you must re-check with `get_draft`.
- A draft cannot read back `master`: after `update_draft` writes `master`, neither its return value nor `get_draft` **contains
  a `master` field**. To confirm the master chain was really written, you can only `render_preset` and then feed the payload to `parse_preset` to reverse it.

---

## 11. `master` is not range-checked when written

The `master` parameter of `update_draft` **has no range validation**; writing `{"masterVolume": 500}` raises no error on the spot,
and only at `validate_draft` / `render_preset` does it report `param_out_of_range`.

Ranges: `masterVolume` is **0..200**; the other 10 master chain parameters (`filter`, `saturation`, `phaser`,
`reverb`, `compThreshold`, `compRatio`, `compAttack`, `compRelease`, `compGain`, `compMix`)
are **0..100**. Voice parameters (`decay` / `tune` / `filter` / `pan` / `volume`) are also 0..100.

**Generally do not touch master chain parameters**: the sound is mainly determined by the kit and the master chain, and factory PRESETs never touch voice parameters.
Unless the user explicitly asks for a sound adjustment, do not touch them. Note that this caution is about the **master chain**: the
Mixer parameters of the voices themselves (`tune` / `filter` / `volume` / `decay` / `pan`) are a legitimate musical choice on any
voice of any kit when the user asks for a particular sound — see SKILL.md section 4.6, which documents the technique and the snare
rimshot as its worked example.

---

## 12. Tool field names are not wire field names

| Used in tool arguments | But in `spec` / DHP3 payload it is |
| --- | --- |
| `triggers` | `g` |
| `ratchets` | `r` |
| `flams` | `f` |
| `velocities` | `vel` |

Writing `g` / `r` / `f` / `vel` / `sub` in tool arguments reports `Unrecognized key` outright.
There is exactly one point where the two sets of names switch: the `spec` emitted by `parse_preset`, which can be edited and handed
straight to `render_preset` (that path uses the wire names); in every other case always use the tool names.
`tags` is the one field that does **not** switch names — same spelling in tool arguments and in the `spec`. Its trap is a different
one; see item 19.

---

## 13. Locating a voice with `role` can be ambiguous

`kit-10` Trap has 3 hats, `kit-25` Percussion has 8 percs.
Locating by `role` takes the one with **the smallest index** and gives a `multiple_role_candidates` warning.

**Right way**: after `get_kit` gives you the voice table, **locate by `index`**.
Locating by `name` works too (case-insensitive, exact match), but in the same kit `Snare` and `Snare2` are two different voices.

---

## 14. accent and chain make no sound even if you write them

The engine does not read these two fields; writing them produces no audible difference at all.

**Right way**: do not use them. For accent layering use `velocities`.

---

## 15. Do not restate the payload in the link

Both links given by `render_preset` — `url` and `deeplink` — carry the same long base64url payload (several thousand characters).

**Consequence**: restating either one character by character drops characters extremely easily, and the user gets a broken payload.
You cannot talk yourself out of this one — the damage is already in the string, and re-reading your own output will not reveal it.
The same applies to "helpfully" assembling the deep link yourself: copying the `p` value out of `url` and prepending
`drumai://import?p=` is hand-transcription under a different name.

**Right way**: hand over both fields exactly as returned, each in a code block — the `deeplink` for a device with
the app installed, the `url` for the preview page and its "Open in App" button. Both are built server-side from
one payload; there is nothing for you to assemble. Do not truncate them, do not substitute "generated" for them,
do not copy out a separate payload text.

**When it has already happened**: if the user reports a link that will not open, the page's **"Copy error details"**
button hands back the reason and the failure code in one short block. A `payload_length_invalid` or `inflate_failed`
code confirms characters were lost in transit. Then re-issue with a fresh `render_preset` and say so plainly —
see SKILL.md §6, "If the user comes back with a broken link".

---

## 16. `render_preset` only produces DHP3; 330 steps is the limit of the **old format**, not your limit

What `render_preset` produces is a DHP3 link, **not bound by a step limit**.
Above roughly 330 steps (8 voices) it gives the `dhp2_step_limit_exceeded` warning —
that is saying "converting this pattern to DHP2 share text would exceed the limit and an older App version could not import it",
**not that there is something wrong with what you produced**. Deliver as normal; there is no need to shorten the pattern for this.

---

## 17. `grid16th` cannot be used directly

The `grid16th` returned by `list_style_templates` is a **fixed 16-character sixteenth-note reference string**,
unrelated to the target grid density; `apply_style_template` scales it when applying.

**Consequence**: stuffing it into `set_voice_grid` as a trigger grid does not match the length on a draft with 12 steps per bar or 20 steps per bar,
and reports `step_count_mismatch` (this one does stop you, but you waste a round trip).

**Right way**: to apply a template, call `apply_style_template`; do not carry `grid16th` over yourself.

---

## 18. The `ts` notation looks the same as "subdivision 1/8" in the App UI but is completely unrelated

In `ts: "4/4"` the numerator is "how many beats per bar" and the denominator is "which note counts as one beat".
"Subdivision 1/8" in the App UI is the **cell length**, which in the MCP corresponds to the integer `cellsPerQuarter: 2`.

**Consequence**: when the user says "the eighth note is one beat", that is `ts: "x/8"`; mismatching it onto `cellsPerQuarter: 2`
raises no error, it just puts the whole pattern inside the same beat.

**Right way**: when the user describes "how many notes go in one beat", ask clearly whether they mean the **time signature** or the **cell density**;
if you are unsure, state how you intend to set it and let the user confirm.

---

## 19. `tags` is omitted when empty, and unknown slugs are dropped when reading but rejected when writing

Tags are style metadata from a fixed 14-value vocabulary (`rock pop funk hiphop trap house techno dnb lofi
jazz latin rnb reggae acoustic`); the app's PRESET library shows them and filters by them. Two traps:

- **Empty means omitted, everywhere.** When a PRESET has no tags, the `tags` key is **absent** from every tool
  return value, from the `spec`, and from the DHP2 share text — it is **never** `"tags": []`. So a "did my tags
  stick?" check must look for the **presence of the key**, not for a non-empty array; an empty array is a state
  that never appears.
- **Dropped when reading, rejected when writing.** Tags read from an external source (a pasted DHP2 string, or a
  `tags` array in a hand-written `spec`) are normalized: unknown slugs are dropped, duplicates removed, and the
  survivors sorted into the fixed vocabulary order. But the `tags` input of `create_draft` / `update_draft` is a
  **strict** schema — an unknown slug there is rejected outright, with an error listing every valid value, so
  you self-correct from the message. The same slug read from a string is silently dropped. See tools.md §8 and §18.

**Right way**: pass tags whenever you can tell the style (the app filters by them, so an untagged PRESET is harder
to find again); when you read tags back, look for the key itself rather than its length.
