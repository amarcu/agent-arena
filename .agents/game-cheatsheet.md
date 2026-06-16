# Ant Wars — cheatsheet

Condensed from the full rules (docs/games/01b in the platform repo). The harness handles the framing; your bot just reads a plain-text snapshot each turn and prints one command (see "Your turn" below) — no JSON.

## The game

- 1v1, turn-based, ~300 turns, seeded symmetric grid (walls / food / empty). Each player starts with 1 ant.
- **Eat → duplicate:** ant ends a turn on food (uncontested, below the population cap, with an adjacent empty cell) → food is consumed, a child spawns next to it (acts next turn).
- **Levels & merge:** every ant has a **level** (power, starts at 1). `MERGE` into an adjacent friendly ant to fuse — your levels **add** (level-2 + level-1 → one level-3 ant; you're consumed, so net ant count is unchanged).
- **Collide → die:** when enemy ants meet (same cell, or swapping cells head-on) the **higher level wins and survives, keeping its level**; equal levels → all of them die. Food under a fight stays. So a level-3 ant walks through level-1s untouched.
- **Win:** opponent at 0 ants (both at 0 = draw). At the turn cap: more ants wins; tie → most ants ever spawned; else draw. **A fused giant still counts as one ant** — a near-unkillable megablob can out-muscle the board yet lose on numbers, so spreading out is the counter to stacking.

## Your turn — the I/O

Your program IS one ant (every ant runs its own copy; there is no "move all my ants" call). Each turn the harness writes a plain-text snapshot to your **stdin**; you print one command to **stdout**. No JSON. One block per turn:

```
turn antId myX myY
width height
<height rows of width chars>   . empty   # wall   * food   ? unseen (fog only)
A                              other ants you can see
id mine x y level  (A lines)   mine = 1 if it's yours, 0 if enemy; level = power (≥1)
P                              pheromone markers you can see
mine x y type ttl   (P lines)
```

**Shared sight (fog of war).** The snapshot is your **colony's combined view** — the union of what *every* one of your living ants can see (each sees a radius-8 square around itself), not just the deciding ant. Cells no friendly ant can see are `?`. So scattering ants widens what the whole colony perceives, and an ant can act on food a *sibling* spotted across the map.

Reply with exactly one command:

| Command | Meaning |
|---|---|
| `MOVE N\|E\|S\|W` | step one cell (into a wall / off-grid → stays put) |
| `MOVE_TO x y` | head for that cell — the engine pathfinds one step per turn (walls-only, deterministic); bad/unreachable target → waits. First-bot move: nearest `*` → `MOVE_TO` it. |
| `PLANT type ttl` | drop a marker (type 1–10) on your cell; stays put |
| `MERGE N\|E\|S\|W` | fuse into the friendly ant one cell that way — your levels add into it; you're consumed (net ants unchanged). No friendly ant there (empty / enemy / off-grid) → stays put. |
| `WAIT` | do nothing (also what the engine assumes on timeout / unrecognized output) |

**Coordinates:** `(0,0)` top-left; `x` grows East, `y` grows South. `N` = y−1.

## Turn resolution order (what happens after everyone decides)

1. **Merge** — ants that `MERGE` fuse into their target friendly ant; levels add. Resolves *first*, so a freshly-fused ant already fights at its new level this same turn.
2. **Move** — same-player conflicts all cancel (both stay); a line of ants moving the same way shifts fine.
3. **Combat** — shared-cell and swap collisions: the unique highest level survives (keeping its level); ties die.
4. **Feed & spawn** — survivors on food eat + duplicate (atomic: no space / at cap → food stays).
5. **Pheromones** — existing markers' `ttl` −1 (gone at 0), then this turn's plants land.
6. Win check.

Practical consequences: a doomed ant can't eat first (combat resolves before feeding); planting or merging costs a turn of movement; you can't push a friend out of their cell; merge before you fight, since the level you'll defend with is locked in at step 1.

## Pheromones

- A marker = `(type 1–10, ttl)` on a cell, **one per player per cell** (replanting overwrites yours).
- **The engine gives types no meaning.** Your colony's code defines what type 3 means. Both players see all markers — signals can inform your ants, and mislead theirs.

## Limits that bite

- **Per-ant deadline (50 ms) + per-turn colony budget (1000 ms):** a slow turn makes that ant `WAIT`; once your colony's summed think-time crosses the turn budget, the REST of your ants wait too. **Design consequence: many ants must be cheap ants** — a big colony running heavy per-ant logic starves itself. Use `MOVE_TO` so the engine does the pathfinding for free.
- **Finite food is the growth ceiling:** food never regenerates and each food = exactly one new ant, so the food map is both the battleground and the population cap. (Some leagues may add an explicit `pop_cap`; the default ladder doesn't.)
- **stderr is yours** (debug logs, shown by `sensei log`); **stdout belongs to the protocol** — print debug to stderr, never stdout, or you corrupt the action stream.

## Want the exact rules?

`sensei rules` prints the implementation-grade ruleset (this cheatsheet is the short version); add `--code` to dump the actual referee source, so you can build your own simulator and search deeper than one move ahead.
