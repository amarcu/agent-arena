---
name: loss-review
description: Scientific-debugging ritual after a lost match or losing streak in Ant Wars. Use when the bot lost, the win rate dropped, the player asks why they're losing, or before editing bot code in response to any defeat. Enforces predict, watch the replay, observe, hypothesize, then experiment.
---

# Loss review — the scientific debugging ritual

Losses are the curriculum. This ritual is how a defeat becomes understanding —
and it is the one habit players drop the moment nobody enforces it, so you
enforce it: **no bot edits until step 4 has produced a named hypothesis.**
(If the player says "just fix it," compress the ritual, don't skip it: watch
the replay yourself, name the hypothesis in one line, then build.)

If this is the session's first exchange, run the AGENTS.md session start
first — `sensei status --json`, profile — then this ritual.

## The ritual

1. **Predict** (before opening anything). Player, one line: "what do you think
   we'll see go wrong?" A wrong prediction is a finding, not a failure.
2. **Watch** — `sensei replay latest` (or the specific lost seed), open on
   *their* screen. Watch the whole thing once without commentary, then replay
   the turns that mattered and point at them.
3. **Observe, then name the pattern** — the pattern, not the moment: "we lose
   the food race on the contested flank," not "turn 41 was bad." Let the
   player name it first; sharpen theirs rather than replacing it.
4. **Hypothesize** — one sentence, falsifiable, about *why* the pattern
   happens. Check it against the misconception list first, before inventing
   something exotic:
   - assumed colony-wide memory (`per-ant-memory` — each ant's memory is
     private, persists only for its own lifetime, and dies with it; the board
     is the only shared state)
   - forgot the fog (`fog` — acted on cells no friendly ant can see)
   - printed debug to stdout (corrupts the protocol; stderr is yours)
   - forgot the resolution order (merge → move → combat → feed — a doomed ant
     never eats first)
   - every ant chasing the same target (`spread` — clumping, wasted turns)
   A misconception behind a concept the profile marks *verified* or *fluent*
   demotes it to *shown* and adds a Recheck line — in the same profile edit
   as the hypothesis, before any code, and before the sentence telling the
   player you demoted it. The edit is the claim; describing one you didn't
   make is a false statement.
5. **Experiment** — the smallest change that tests the hypothesis, one concept
   only. Commit first (message = the hypothesis). Then measure:
   `sensei match --against baseline --n 20 --json` and, if a specific seed
   showed the pattern, rerun that exact seed.
6. **Conclude** — did the number move and does the replay look different at
   the same spot? Keep or revert on the answer. Either way, one `JOURNAL.md`
   entry: *Change / Why + expected / Measured* — and when a specific seed
   showed the pattern, put the seed number in the Measured line ("seed 7
   fixed"); those seeds become the pre-submit regression checks.

## Register notes

- Mentor: the player states steps 1, 3, 4 in their own words — you probe, you
  don't supply. If they're stuck, climb the hint ladder, don't skip to the fix.
- Peer: same steps, half the words — trade observations as equals, disagree
  freely, but the replay still gets opened and the hypothesis still gets named
  before code changes.

## Anti-patterns you are guarding against

- Diagnosing from the score alone ("must be the targeting") without the replay.
- Fixing two things at once — you learn nothing from the measurement.
- Describing a replay the player never saw. Open it, point, then talk.
