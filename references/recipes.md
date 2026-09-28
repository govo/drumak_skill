# End-to-End Recipes

Four complete, runnable recipes, all copied verbatim from calls that passed in real testing. The examples are written for the script channel (`bash scripts/call.sh ...`),
so when you go through the MCP tool channel, just move the "tool name + JSON" over as-is.

All four recipes follow the same skeleton:

```
pick a kit → write the pattern (all voices in one pass) → add a fill → self-check → render_preset for the link
```

**Remember that `hits` repeats in every bar.** The multi-bar recipes below always use `triggers` to write per-bar grids.

---

## Recipe 1: House (one bar, the simplest)

```
1) create_draft
   {"kit":"kit-8","name":"Skill House 124","bpm":124,
    "cellsPerQuarter":4,"bars":1,"humanize":0.02}

2) set_voice_grid        # all 4 voices in one pass
   {"draftId":"<returned by the previous step>","voices":[
     {"index":0,"triggers":"x---x---x---x---"},
     {"index":3,"hits":[{"beat":2,"offset":"downbeat"},{"beat":4,"offset":"downbeat"}]},
     {"index":5,"triggers":"--x---x---x---x-"},
     {"index":4,"triggers":"x-x-x-x-x-x-x-x-",
      "velocities":{"0":0.7,"2":1,"4":0.7,"6":1,"8":0.7,"10":1,"12":0.7,"14":1}}]}

3) validate_draft        {"draftId":"..."}
4) render_preset         {"draftId":"..."}
```

Key points:

- In `kit-8` House, index 1 is the **bass** — leave it empty if you don't want a bass line; index 3 is the clap, 4 the closed hat, 5 the open hat.
- Use `triggers` for the four-on-the-floor kick; use `hits` for the off-beat clap to save trouble (that is beats 2 and 4).
- Give the closed hat alternating accents (velocity 1 on the eighth-note positions, 0.7 in between) and the groove appears immediately.
- The open hat sits on the second half of each beat (`--x---x---x---x-`) — this is the signature house sound.

An easier equivalent: `apply_style_template {"templateId":"house"}` gets it done in one step,
but it only gives you the `grid16th` skeleton; you still have to add the velocity layers yourself.

---

## Recipe 2: Boom Bap (4 bars + a fill in the last bar + swing)

```
1) create_draft
   {"kit":"kit-18","name":"Skill BoomBap 92","bpm":92,
    "cellsPerQuarter":4,"bars":4,"groove":["swing",0.22],"humanize":0.08}
   Note: get bars right here in one go. Changing bars after writing the pattern rebuilds the grid (see footguns item 10).

2) set_voice_grid        # 4 bars = 64 steps, written bar by bar with triggers
   {"draftId":"...","voices":[
     {"index":0,"triggers":"x-------x-x-----x-------x-x-----x-------x-x-----x-------x-x---x-"},
     {"index":2,"triggers":"----x-------x-------x-------x-------x-------x-------x-------x---"},
     {"index":4,"triggers":"x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-"}]}

3) apply_fill_mode       # add a fill to the snare in the last bar
   {"draftId":"...","voices":[{"index":2}],"fillMode":"lastBar","seed":7}
   → the whole row becomes "------------------------------------------------xx--x-xxxxxxx-xx"
     **Note that this is a whole-row replacement: the snare in the first 3 bars gets wiped**, not just the last bar being replaced by the fill.
     Don't use it this way when what the user wants is "keep the original beat, add a fill in the last bar" (see footguns item 10),
     either write the last bar yourself with triggers, or copy the original grid down first, apply the fill, then write the first 3 bars back.

4) validate_draft → render_preset
```

Key points:

- `lastBar` has `minBars` 2, so 4 bars is enough;
- Random-containing modes need a `seed` to be reproducible (`lastBar` is `deterministic: false`);
- **Add the fill before building the velocity layers** — `apply_fill_mode` resets that row's velocities back to 1;
- swing is a timing offset and comes from the `groove` parameter; don't try to write it into the grid.

---

## Recipe 3: Trap (2 bars + ratchet hi-hat)

```
1) create_draft
   {"kit":"kit-10","name":"Skill Trap 140","bpm":140,
    "cellsPerQuarter":4,"bars":2,"humanize":0.02}

2) set_voice_grid        # 2 bars = 32 steps, all 32 characters written out with triggers
   {"draftId":"...","voices":[
     {"index":0,"triggers":"x-----x---x-----x-----x---x-----"},
     {"index":2,"triggers":"--------x---------------x-------"},
     {"index":3,"triggers":"--------x---------------x-------"},
     {"index":4,"triggers":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "ratchets":"------------r-r-----------------",
      "velocities":{"0":1,"2":0.6,"4":0.75,"8":1,"12":0.7}}]}

   Voice mapping: 0 sparse syncopated kick / 2 snare on beat 3 / 3 clap layered on the snare /
   4 sixteenth-note hi-hat (with local rolls and velocity layers).

3) Confirm the ratchet was really written (see below)
4) validate_draft → render_preset
```

**Every grid string's length must equal `bars × stepsPerBar`** (here 2 × 16 = 32).
If it's short it gets silently padded with `-`, which sounds like "no sound in the second half" (footguns item 4). Count the length before you copy.

Key points:

- **A trap kick should be sparse** — don't fill it up; landing the snare on beat 3 is common practice.
- `kit-10` has 3 hats among indices 4/5/6/7 (`Hat`/`Hat2`/`Hat3`); switch indices for a timbre change,
  but **locate them with `index`** (`role: "hat"` takes the lowest-index one).
- Don't fill every step with ratchets: two or three of them is a roll, filling them all is noise. A `ratchets` string **must be exactly 32 characters**:
  too long is an error, too short **doesn't error but silently truncates the meaning** (see footguns item 4). Count the length before you copy.

### How to confirm a ratchet / flam was really written

`get_draft`, `set_voice_grid`, and `render_preset.preview` **do not display `r` / `f`**; all you can see is `triggers`.
They really are written (they're in the payload), but to see it with your own eyes you have to decode it back:

```
1) render_preset {"draftId":"...","include":["url"]}     → get the url
2) Take the payload after p= in the url and feed it to parse_preset:
   {"input":"<payload>"}
3) Look at the returned spec.voices[].var[]; only if r / f / vel are in there were they really written
```

Measured in practice, the output of this path looks like:

```json
[ { "i": 2, "var": [ { "g": "----x-------x---", "f": "----f-----------" } ] },
  { "i": 4, "var": [ { "g": "x-x-x-x-x-x-x-x-", "r": "----r-------r---",
                       "vel": { "0": 1, "4": 0.6 } } ] } ]
```

This is also **the only way to prove the sound details to yourself before delivery**, and it's worth making a habit.

---

## Recipe 4: Start from a built-in PRESET and turn it into 4 bars

This is the one most easily written as a "4-bar PRESET where only bar 1 makes sound". The full path is below; don't skip any step:

```
1) get_reference_preset {"presetId":"preset-slime-time"}
   → note down preset.kitId / preset.bpm / preset.voices[].grids[0] (variation 0 is the one that sounds)

2) create_draft
   {"kit":"kit-10","name":"Slime Time","bpm":124,"fromPresetId":"preset-slime-time"}
   Note: kit / name / bpm are **required**, but they get overwritten by the PRESET's values — filling them in is pointless, and leaving them out is an immediate error.
   It returns bars=1, and the name can't be changed.

3) update_draft {"draftId":"...","transport":{"bars":4}}
   It returns only a grid_resized warning. **At this point bars 2-4 are empty.**

4) set_voice_grid        # the key step: repeat grids[0] bar by bar until it's full
   Give each voice {"index": N, "triggers": "<grids[0] written out 4 times in a row, 64 characters total>"}
   (below is the template; fill the actual grid into the angle brackets)
   {"draftId":"...","voices":[
     {"index":0,"triggers":"<grids[0]×4>"},
     {"index":1,"triggers":"<grids[0]×4>"}]}
   Only write the voices that have an x in grids[0]; skip the ones that don't. Skip this step and the first 3 bars are silent.

5) validate_draft → render_preset
```

Key points:

- **Besides `grids[0]` there are grids[1..3]**: a built-in PRESET stores 4 variations, and only index 0 makes sound.
  Don't take grids[1] for "bar 2" — that's another variation.
- If you want the last bar to differ, change the last 16 characters yourself in step 4 — **do not use the
  `lastBar` of `apply_fill_mode`**, it wipes the first 3 bars along with it (footguns item 10).
- **Velocities and the master chain do not carry over.** `get_reference_preset` only gives you the grids,
  so the draft it creates has empty `velocities` and a default `master` chain, and sounds "drier" than the factory one.
  To restore it you have to add `velocities` yourself and set `master` through `update_draft` (for the master chain, see footguns item 11 first).
- Want to give this new PRESET a name of its own? The `fromPresetId` path can't do it (`name` gets overwritten, and
  `update_draft` has no `name` field). For a name of its own, drop `fromPresetId` and
  `create_draft` by hand with the kit / bpm / groove from step 1.

---

## Counter-example: the user pastes a `DHP2;...` blob and says "change this"

```
1) parse_preset  {"input":"DHP2;k=kit-10;b=124;n=...;d=..."}
   → returns the spec (wire field names: g / r / f / vel / var)
2) Edit this spec
3) render_preset {"spec": <the edited spec>}
```

Key points:

- This is the only path that uses the **wire field names** (`g` / `r` / `f` / `vel`); what you edit is the `spec`, not a draft,
  so it doesn't go through `set_voice_grid`.
- After checking `diagnostics.droppedFields`, if it's non-empty tell the user in your reply what was dropped (DHP2 drops `compBypass`).
- DHP2 carries no bar count, so `bars` is inferred backwards and may differ from the original — say so up front, don't change it silently.

**The more robust approach**: after `parse_preset` hands you the spec, rebuild a draft with `create_draft`,
then edit it with `set_voice_grid`. That way you can check every step with `get_draft`, at the cost of a few extra calls.
It's worth doing when the user pastes **someone else's** share text and asks for major changes.

---

## Read-only variant: the user pastes a `DHP2;...` blob and asks "what is this?"

Do not reach for `parse_preset` if nobody is going to edit anything — it returns a `spec` in wire field names,
and reading a grid out of it means counting characters. `render_wireframe` takes the same input and draws it:

```
1) render_wireframe  {"input":"DHP2;k=kit-10;b=124;n=...;d=..."}
   → score: the pattern as a wireframe score
   → voices[]: only the voices with notes, each with its triggers string
   → silentVoices[], plus notes about dropped fields / velocities / ratchets / flams
```

Quote the `score` block back to the user in your reply (a code block keeps the columns aligned) and describe
what it does. It is read-only: no draft is created, no state changes, so it is also the cheap way to compare
two pasted PRESETs or to check what you just produced before delivering it.
