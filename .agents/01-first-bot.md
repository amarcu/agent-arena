# Phase: First bot

**Goal:** the player teaches their wandering ant to chase food, then beats the baseline bot — and understands every line that got them there. **Exit criteria:** ≥ 60% win rate over `sensei match --against baseline --n 20`, *and* the player has explained the greedy approach back in their own words (mark it verified in the profile).

> First, make sure they've actually *seen* the game — rules at their level, a match watched together. Coding before they understand what wins is the mistake this phase exists to avoid. Returning or peer players who know the game: skip ahead.

## 1. Trace one tick (the notional machine — don't skip this)

Before strategy, verify the player can trace **one full turn** of the machine their code lives in: the harness writes a text snapshot to stdin (their ant's position, the visible grid, nearby ants) → their program computes → prints exactly one command to stdout → the engine resolves everyone's commands in a fixed order (merge → move → combat → feed → pheromones). Two facts trip everyone and are worth stating plainly:

- **You write one ant, not a colony.** Every ant runs this same program independently; "my ants" emerge from one ant's logic being good.
- **Each process is one ant's lifetime.** Memory persists turn-to-turn for *that ant*, but there is no colony-wide variable — the board (and pheromones) is the only shared state.

Check it lands with one question — "so if you set a variable this turn, which ants see it next turn?" — and re-anchor every later bug explanation in this model. Then tour the starter in `bot/` (it's short on purpose): a read-then-print loop that currently reads the whole snapshot and **keeps none of it**. Ideally the player names the gap themselves (*"what's it not doing with all that input?"*).

## 2. First upgrade: chase the food

Coach it as a discussion, not a spec. The upgrade has two halves — **keep** what you read, then **use** it:

- **Stop discarding the grid.** Store the rows as they're read (`grid[y][x]`, or a set of `*` food coordinates). Designing the representation is genuinely part of the task — let them choose.
- **Chase the nearest `*`.** Find the closest food, go to it. Once the idea exists, name it: **greedy** — take the nearest, no long game. "Nearest" on a no-diagonals grid = **Manhattan distance**, `|Δx| + |Δy|` — one plain sentence each, then move on.
- **Getting there is free:** `MOVE_TO x y` pathfinds one step per turn around walls. So the core is tiny: nearest `*` → `MOVE_TO`; no food in sight → keep the starter's wander as fallback.

**Mentor mode — the player types the core.** Structure it as named subgoals and hand over a skeleton, not a solution:

```
# subgoals: sense (parse + keep the grid) → pick target (nearest food) → act (MOVE_TO or fallback)
def pick_target(foods, me):
    # TODO(you): return the food with the smallest |dx|+|dy| from me
```

You write the parsing boilerplate if they want; they write `pick_target`. Review what they wrote like a colleague's PR — praise what's right, question what's off, fill gaps only on request. This is the **modeling → coaching** part of the arc: you narrated the plan, they implement it. (First worked example can be fuller; by the next algorithm they get only the subgoal names; by mid-ladder they get a blank editor — that fading is deliberate, announce it as roles shift.)

**Predict, run, compare.** Before the first run: "which number moves, and what will the replay look like?" The moment it works, watch the replay together — ants converging on food and spawning copies is the payoff shot, worth a genuine "look at that." Then the explain-back: *why* does greedy beat wandering, and when would greedy be the wrong call? A sound answer promotes `greedy targeting` to verified. This step usually flips the result against `random` decisively, and often clears the baseline too.

## 3. The improvement ladder (reach for a rung when the losses point at it)

Don't front-load these — watch a lost replay together first (the loss-review ritual in `.agents/skills/loss-review/SKILL.md`), name the pattern, then pick the rung that addresses it. One concept per iteration.

1. **Don't die:** never step onto a cell an enemy could also reach this turn. Trading one-for-one is fine *only* when ahead on ants.
2. **Spread out:** every ant chasing the same food wastes turns. No memory needed — rank ants by distance to each food; the closest claims it, others take their next-best. Every ant computes the same ranking from the same board, so they agree without communicating.
3. **Don't block friends:** the engine cancels same-player move conflicts — two ants wanting one cell both stall. The spread-out logic mostly fixes this free.

Greedy + don't-die usually clears the 60% bar.

## 4. Measure every change

`sensei match --against baseline --n 20 --json` — quote win rates before/after ("35% → 70% over 20"). Fixed `--seed` to debug one situation; the `--n 20` spread to judge if an improvement is real. Every kept change: commit (message = hypothesis) + a 3-line `JOURNAL.md` entry. And don't stop at the number — open the replay the same turn you report it.

## Common first-bot failures

- **Timeouts:** each turn has a per-ant deadline (~50 ms). `MOVE_TO` keeps a first bot clear of it; `sensei log` shows per-call timing when it bites later.
- **Invalid commands** (treated as `WAIT`): typo, missing argument, or debug accidentally printed to stdout. Debug goes to stderr, always.
- **Falling out of sync:** the bot must read the *whole* per-turn block before printing, or every later turn misparses. The starter reads past what it doesn't use — keep that.
- **The ant-mill:** ants oscillating A→B→A forever. Two fixes, and picking one is a nice design conversation: remember your last cell and refuse to bounce straight back (per-ant memory persists — use it), or break ties deterministically (prefer distance-reducing moves; on exact ties, order by `ant_id` parity so twins tie-break differently).

When the exit criteria is met — win rate *and* explain-back — mark the moment in-register (mentor: beating the baseline is this platform's "it compiles and it *thinks*" moment; peer: "baseline's dead — ladder?"). Then `.agents/03-submit-and-climb.md`.
