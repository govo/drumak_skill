# Tool Reference: Parameters, Return Values, and Error Semantics of the 18 Tools

The authoritative source is the schema returned by the server's `tools/list` (`bash scripts/call.sh --list` to see the names).
This document adds what the schema does not show: default values, actual behavior, and **the parts that bite**.

`*` marks required, `?` marks optional.

---

## 1. Tool-layer field names differ from wire field names

You will encounter wire field names when reading `parse_preset`'s return value or writing a `spec` by hand. The correspondence between the two sets of names:

| wire (DHP3 payload, `spec`) | tool parameters / return |
| --- | --- |
| `g` | `triggers` |
| `r` | `ratchets` |
| `f` | `flams` |
| `vel` | `velocities` |
| `var` | (no corresponding parameter; use the `variation` index) |
| `i` | `index` / `name` / `role` |

**Writing `g` / `r` / `f` / `vel` / `sub` in tool parameters errors outright with `Unrecognized key: "..."`.**
This is deliberate: `create_draft`, `set_voice_grid`, and `update_draft.transport` use a strict schema,
and would rather error than silently drop (silent dropping would make you believe it was written).

---

## 2. Knowledge tools (7, read-only)

### 1. `list_kits`

```
{ style?: string, includeInstruments?: boolean }     // includeInstruments defaults to false
```

Returns `kits[{ id, name, styles, character, bestFor, instrumentCount }]`.
With `includeInstruments: true` there is an extra `instruments[{ index, name, role, hint, params }]`.

- The `style` filter is **normalized bidirectional containment** (strips `-` and whitespace, lowercases); `"trap"` can match a `hip-hop` kit.
- When nothing matches it returns `{ ok:false, allStyles:[...] }`; use it to see which styles are available.
- 24 kits: `kit-0` to `kit-25` (the numbering is not contiguous).

### 2. `get_kit`

```
{ kitId*: string }        // e.g. "kit-10"
```

**You must call it before writing any drum pattern.** The same index is a completely different voice in different kits:

- `kit-0` 808: index 1 is the second kick
- `kit-8` House / `kit-9` Techno / `kit-17` Techno DM: index 1 is the **bass**
- `kit-10` Trap: 3 of indices 4/5/6/7 are hats (`Hat`/`Hat2`/`Hat3`)
- `kit-25` Percussion: all 8 are percussion, **there is no kick and no snare**, and a conventional pattern cannot be applied

The return carries `notes.duplicatedRoles`, listing the cases where "one role corresponds to multiple voices in this kit".
If locating by `role` hits such a case, the one with the **smallest index** is taken and a `multiple_role_candidates` warning is issued.

A voice's `id` is always `inst-0`..`inst-7`; **it is not distinctive, do not use it to locate a voice**.

### 3. `list_grid_options`

```
{ timeSignature?: string, cellsPerQuarter?: 2|3|4|6|8 }    // if neither is given, all combinations are returned
```

It returns, for each combination, `timeSignature`, `cellsPerQuarter`, `isTriplet`, `isCompound`,
`stepsPerBar`, `stepsPerBeat`, `offsets[]`, `beatGroups[{beat, stepRange}]`, `isRegularBeats`.

Common reference (use it to check before writing literal grids):

| time signature + cellsPerQuarter | stepsPerBar | stepsPerBeat | offsets |
| --- | --- | --- | --- |
| 4/4 + 4 | 16 | 4 | `downbeat e and a` |
| 4/4 + 3 | 12 | 3 | `downbeat triplet2 triplet3` |
| 4/4 + 2 | 8 | 2 | `downbeat and` |
| 4/4 + 6 | 24 | 6 | `downbeat 1 2 3 4 5` |
| 4/4 + 8 | 32 | 8 | `downbeat 1 .. 7` |
| 6/8 + 4 | 12 | 6 | `downbeat 1 .. 5` |
| 6/8 + 3 | **9** | 4 | irregular, `isRegularBeats=false` |

**`cellsPerQuarter` and `stepsPerBeat` are equal only under x/4 time signatures.** 6/8 is compound meter,
a "beat" is a dotted quarter (= 3 eighth notes), so 6/8 + 4 is 6 cells per beat and 12 cells per bar.

`triplet2` / `triplet3` in `offsets` are merely names for "the 2nd and 3rd cell",
**they do not mean a triplet is there** (under 6/8 those three cells are three eighth notes).

### 4. `list_fill_modes`

```
{}
```

20 fill modes. Split into two classes by `scope`:

- `single_bar` (minBars=1): `clear` `random` `fourOnFloor` `oneThree` `backbeat`
  `eighth` `sixteenth` `eighthTwoSixteenth` `twoSixteenthEighth` `dotted`
  `syncopated` `offbeat`
- `cross_bar`: `every2Bars`(2) `lastBar`(2) `callResponse`(2) `every4Bars`(4)
  `pullBack`(4) `buildUp`(4) `questionAnswer`(4) `oneThreeFill`(4)

Modes with `deterministic: false` (`random` `oneThree` `backbeat` and all `cross_bar`)
can only be reproduced with `seed`; without `seed` they are truly random.

**The "beat" in a mode name is computed by dividing the bar evenly, not the beat of the time signature.** See `footguns.md` item 5.

### 5. `list_style_templates`

```
{}
```

8 style templates: `four_on_floor` `backbeat` `house` `trap` `breakbeat` `shuffle` `boom_bap` `funk`.
Each returns `bpmRange`, `recommendedCellsPerQuarter`, `recommendedGroove`, `humanize`,
`recommendedKits`, `voices[{ role, grid16th, ratchets16th? }]`.

`grid16th` is a **fixed 16-character 16th-note reference string**, not a trigger grid you can use directly —
it is scaled to the target step count when applied. A template is only a starting point; after applying it you still have to adjust it to the requirement.

### 6. `list_reference_presets`

```
{}
```

22 built-in PRESETs (11 basic + 11 triplet versions whose names carry a ` T` and whose ids end in `-t`).
Returns `kitId`, `bpm`, `cellsPerQuarter`, `isTriplet`, `stepCount`, `voiceSummary`.

### 7. `get_reference_preset`

```
{ presetId*: string }      // e.g. "preset-slime-time"
```

Returns the complete grids of 8 voices × 4 variations.
**Only the 1st variation (index 0) sounds**; looking at the other three is only to understand the author's intent.
Each voice's `grids` is an **array of length 4**, and `grids[0]` is the one that sounds —
`grids[1]` is not "bar 2".

This reference library has **only trigger grids**: no velocities, ratchets, flams, or master chain.
So a draft copied from it has empty velocities and a default master chain, and does not sound the same as that factory PRESET inside the app.

For PRESETs that carry `swing` (e.g. `preset-slime-time` is 38), mind the scale:
in a PRESET it is **0..100**, while MCP's `groove` is **0..1**. Using it as the starting point of a draft converts automatically and gives a warning
(the warning's `code` is `kit_changed`, **unrelated to changing kits**; the code is used for the wrong thing, just ignore it).

---

## 3. Draft tools (9)

### 8. `create_draft`

```
{
  kit*: string,                   // see list_kits
  name*: string,                  // empty string or >64 chars errors with name_too_long
  bpm*: number,                   // 30..360
  ts?: string,                    // "N/D"; the denominator may only be 4 or 8; defaults to "4/4"
  cellsPerQuarter?: 2|3|4|6|8,    // defaults to 4
  bars?: integer,                 // 1..16; defaults to 1
  groove?: [kind, amount],        // kind: straight|swing|shuffle|blues; amount 0..1
  humanize?: number,              // 0..1; defaults to 0
  fromPresetId?: string           // start from a built-in PRESET
}
```

**`fromPresetId` overrides your parameters** (measured): `kit` / `name` / `bpm` / `cellsPerQuarter`
are all taken from the PRESET, `bars` is **forced to 1**, and `ts` keeps the value you passed.
The three `kit` / `name` / `bpm` are still **required** — fill them in and they are discarded, omit them and it errors outright, and `name` cannot be changed afterwards either.

It **copies only the trigger grids**; velocity / ratchet / flam / master chain do not come along (they are not in the source data).

So with `fromPresetId` you **cannot create a multi-bar draft in one go** — create it and then change `bars` with `update_draft`,
but **after changing it you must repeat each voice's grid bar by bar yourself with `triggers`**, otherwise everything from bar 2 on is empty.
The complete path is recipe 4 in `recipes.md`.

For `groove`'s `amount`, use the `GROOVE_DEFAULT_AMOUNT` magnitude: swing about 0.35, shuffle about 0.62,
blues about 0.72. `straight`'s amount is always 0 (off).

Returns `{ draftId, kitId, ts, cellsPerQuarter, bars, derived:{stepsPerBar, stepCount, offsets} }`.

**A draft with errors is not stored**: even if a `draftId` is returned, subsequent calls will say "the draft does not exist or has expired".
So check `issues` right after creating one.

### 9. `set_voice_grid` (most used)

```
{
  draftId*: string,
  voices*: [ Voice ],
  variation?: integer,             // 0..3; defaults to 0
  mode?: "replace" | "append"      // defaults to replace
}
```

A `Voice` is located by exactly one of three (giving 0 or more than one errors):

```
{
  index?: 0..7,                    // recommended
  name?: string,                   // case-insensitive, exact match
  role?: Role,                     // kick snare clap hat ohat tom perc crash bass synth other

  triggers?: string,               // x triggers, - silent; length should equal stepCount
  ratchets?: string,               // r present, - absent; adds a hit at the midpoint of that step (half a cell)
  flams?: string,                  // f present, - absent; adds a hit 18ms before that step
  velocities?: { "<step index>": 0..1 },   // sparse table, keys are 0-based indices as strings
  hits?: [ { step } | { beat, offset } ]
}
```

Behavior notes:

- **Length rules**: a grid longer than `stepCount` → error `step_count_mismatch`; shorter → warning `grid_padded`
  and padded with `-` on the right. But `ratchets` / `flams` grids **do not error when short** (inconsistent semantics; writing them out in full is safer).
- **`mode: "append"`** only overlays the `x` / `r` / `f` of the new grid; it does not overwrite existing content.
  `velocities` are **merged by key** in either mode.
- **Validated as a whole before writing**: if any voice in one call has an error, **none of them is written**. There is no half-written state.
- **`hits` repeats in every bar** (see `footguns.md` item 1).
- An out-of-range `variation` throws `invalid_variation`.

Returns `{ draftId, derived, voices:[{ index, grids }] }` — **it echoes the grids actually written**; use it to check whether you wrote what you wanted.

### 10. `apply_fill_mode`

```
{ draftId*, voices*: [VoiceRef], fillMode*, variation?, seed? }
```

- `draft.bars < mode.minBars` → error `fill_mode_needs_bars`, **nothing is written**.
  Cross-bar modes need a multi-bar draft (see the table).
- **Whole-row replacement, not overlay.** Every mode regenerates the entire row — and what `lastBar` generates is
  a grid where **only the last bar has content**; the preceding N-1 bars are cleared to `-`. To add a fill to the final bar while keeping the original beat,
  this tool cannot do it; you have to write the final bar yourself with `triggers` (see `footguns.md` item 10).
- **It discards that row's `velocities` (velocities are reset to 1) but keeps existing `r` / `f`.**
- It echoes the grid actually generated; check it.

### 11. `apply_style_template`

```
{ draftId*, templateId*, only?: Role[], variation? }
```

- It maps by `role` onto a voice of the target kit, mapping to the **first** matching voice.
- A role missing from the target kit → warning `role_not_found` and it is skipped. So it works on any kit.
- `triggers` is always overwritten; `ratchets` / `flams` are overwritten only when the template provides the corresponding grid, otherwise the existing value is kept.
- Targets that are not 16 steps/bar are scaled, and scaling loses detail — after applying, it is advisable to look once with `get_draft`.

### 12. `update_draft`

```
{
  draftId*: string,
  transport?: {
    kit?, bpm?, ts?, cellsPerQuarter?, bars?(1..16),
    ref?: "quarter" | "eighth" | "dottedQuarter",   // the counting unit for BPM
    groove?: [kind, amount], humanize?
  },
  voices?: [ { index?|name?|role?, params*: { decay?, tune?, filter?, pan?, volume?, mute?, solo? } } ],
  master?: { filter?, saturation?, phaser?, reverb?, compThreshold?, compRatio?,
             compAttack?, compRelease?, compGain?, compMix?, compBypass?, masterVolume? },
  variationOps?: [ { op*:"copy", from*, to* } | { op*:"clear", index* } ]
}
```

- `ref` and `ts` are two different things: `ref` is which note BPM counts by (default: dotted quarter under compound meter, otherwise quarter).
- **Changing `bars` / `ts` / `cellsPerQuarter` rebuilds all grids** (left-aligned, excess truncated, shortfall padded with `-`,
  out-of-range keys in `velocities` deleted), and gives a `grid_resized` warning. **This is not a lossless operation.**
  **The bars added by enlarging `bars` are empty** — the contents of bar 1 are not copied over;
  you must rewrite them yourself with `triggers` (see `footguns.md` item 10).
- **Changing `kit` keeps the grids but changes what the indices mean** (warning `kit_changed`) — a note originally written on index 1
  may be a completely different voice in the new kit. After changing, you must re-check with `get_draft`.
- The value ranges for `master` are **`masterVolume` 0..200, everything else 0..100**.
  Note that `update_draft` **performs no range validation** when writing `master`; out-of-range values only error at `validate_draft` / `render_preset` —
  no error at the time does not mean it was written correctly.
- **Neither the return value nor `get_draft` contains `master`**, so once written it cannot be read back directly. To confirm it, the only way is to
  `render_preset` and feed the payload to `parse_preset` to reverse it.
- There is no `name` field; **a draft's name cannot be changed once it is created**.
- `variationOps`'s `copy` / `clear` act on **all voices**, not on a single voice.

### 13. `get_draft`

```
{ draftId*: string }
```

Returns the complete draft: transport parameters, `derived`, `voices[{ index, grids, velocities, params }]`.
**The only means of self-checking**; after changing structure (`bars` / `ts` / `kit`) you must take a look.

Note that `grids` is an **array of length 4** (4 variations), and `grids[0]` is the one that sounds.

### 14. `validate_draft`

```
{ draftId?: string, spec?: object }     // one or the other
```

Returns `{ valid, issues:[{ path, code, message, severity }], derived }`.
`severity` has only two levels, `error` and `warning`; **a warning does not affect `valid`**.
Run it once before producing output; do not produce an empty PRESET.

**It only judges that "the whole is not empty"**: a draft with 4 bars where only bar 1 has content is still `valid: true`.
For multi-bar output you must split the `grids` and check bar by bar yourself; do not treat `valid` as a per-bar safety net.

### 15. `list_drafts` / 16. `delete_draft`

```
{}                        // list_drafts
{ draftId*: string }      // delete_draft
```

A draft is **in-memory state of the server process**: it expires after 2 hours, the cap is 500, and it is lost when the service restarts.
The full meaning of `draft_not_found` is "does not exist **or** has expired"; on encountering it, recreate.

---

## 4. Output tools (2)

### 17. `render_preset`

```
{
  draftId?: string,                 // one or the other of draftId and spec
  spec?: object,                    // the complete DHP3 spec
  include?: ("url"|"preview"|"diagnostics")[]    // defaults to all
}
```

Returns:

- `url`: **this is your output**. Of the form `<PUBLIC_BASE_URL>/p?p=<DHP3 payload>`.
- `urlLength`: the length of the link (the payload is long, usually several thousand characters; normal).
- `preview`: readable grids (each voice's `grid` and `hitCount`), for showing the user or for checking yourself.
- `diagnostics`: `{ warnings, derived }`.

Behavior notes:

- It runs `validateSpec` first; **if that does not pass it fails outright** and returns `issues`. No half-finished output is produced.
- **It produces DHP3 only**, not DHP2 share text.
- Being very long (> about 330 steps) gives a `dhp2_step_limit_exceeded` warning —
  **that is not your output being rejected**, it is an advance notice: "this pattern converted to the old format would exceed the limit; older app versions cannot import it".
  DHP3 itself is not subject to a step limit, so just deliver it to the user normally.

### 18. `parse_preset`

```
{ input*: string }        // DHP2/DHPL share text, a DHP3 payload, or a full link
```

Returns `{ ok, source, spec, readable?, diagnostics:{ valid, issues, droppedFields, notes } }`.
`source` is `dhp2` / `dhp3` / `url`.

- Once you have the `spec` you can edit it directly and hand it to `render_preset` (`spec` uses the wire field names:
  `g` / `r` / `f` / `vel` / `var`, **not** the `triggers` set).
- When `droppedFields` is non-empty, tell the user in your reply what was lost. DHP2 drops `compBypass`
  (as well as `lowPass` / `highPass` / `variations` / `chain`).
- DHP2 **does not carry the bar count**; `bars` is inferred and may differ from the original.
- When the input contains a `DHPL;` multi-line container, only the 1st entry is parsed, and `notes` says so.

---

## 5. Error semantics (common to all tools)

A tool failure is **not a transport fault**; it is a normal return with `isError: true`, with a payload of the form:

```json
{ "ok": false,
  "error": "<the message of the first error>",
  "issues": [ { "path": "voices[0].triggers", "code": "step_count_mismatch",
                "message": "...", "severity": "error" } ] }
```

**Read `issues[].path` and `code`, change the parameters and retry; do not retry unchanged.**

Error-level codes:

```
kit_not_found  name_too_long  bpm_out_of_range  invalid_time_signature
unsupported_denominator  invalid_cells_per_quarter  invalid_groove
bars_out_of_range  step_count_mismatch  invalid_grid_char
instrument_index_out_of_range  instrument_name_not_found  invalid_voice_reference
invalid_offset  duplicate_instrument_index  velocity_out_of_range
param_out_of_range  timing_nudge_out_of_range  empty_pattern  fill_mode_needs_bars
```

Warning level (does not affect `valid`, but look at it):

```
grid_padded                 the grid was short, padded with - on the right (may not be what you wanted)
grid_resized                the grid was rebuilt after changing bars/ts/density (losslessness lost)
kit_changed                 index meanings changed after switching kits, you must re-check
multiple_role_candidates    locating by role was ambiguous, the smallest index was taken
role_not_found              the target kit has no such role, it was skipped
variations_beyond_first_ignored   variations 2..4 were written, they will not sound
dhp2_step_limit_exceeded    converting to the old format would exceed the limit, DHP3 is unaffected
```

There are also 5 cases that "throw outright" (`DraftError`, with a `code` in the payload):
`draft_not_found`, `kit_not_found`, `invalid_variation`, `invalid_fill_mode`,
`invalid_style_template`.
