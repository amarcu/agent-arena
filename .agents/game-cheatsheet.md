# Ant Wars — cheatsheet

Condensed from the full rules (docs/games/01b in the platform repo). The template harness handles the wire protocol; bot authors only implement `decide`.

## The game

- 1v1, turn-based, ~300 turns, seeded symmetric grid (walls / food / empty). Each player starts with 1 ant.
- **Eat → duplicate:** ant ends a turn on food (uncontested, below the population cap, with an adjacent empty cell) → food is consumed, a child spawns next to it (acts next turn).
- **Collide → die:** enemy ants on the same cell, or swapping cells head-on, all die. Food under a fight stays.
- **Win:** opponent at 0 ants (both at 0 = draw). At the turn cap: more ants wins; tie → most ants ever spawned; else draw.

## Your function

```
decide(state, ant_id) -> action
```
Called once per *your living ant* per turn, sequentially. Same function, every ant — there is no "move all my ants" call. `state` is the full board.

**Actions**
| Action | Shape | Notes |
|---|---|---|
| Move | `{"type":"move","dir":"N\|E\|S\|W"}` | Into a wall/off-grid → stays put |
| MoveTo | `{"type":"move_to","x":X,"y":Y}` | "Head for that cell" — the engine pathfinds one step per turn (deterministic, walls-only). Bad/unreachable target → waits. Your first bot can be: nearest food → `move_to` it. |
| Plant | `{"type":"plant","pheromone":1-10,"ttl":N}` | Stays put; drops a marker on the current cell |
| Wait | `{"type":"wait"}` | Also what the engine assumes on timeout/invalid output |

**Coordinates:** `(0,0)` top-left; `x` grows East, `y` grows South. `N` = y−1.

## Turn resolution order (what happens after everyone decides)

1. **Move** — same-player conflicts all cancel (both stay); a line of ants moving the same way shifts fine.
2. **Combat** — shared-cell and swap collisions die.
3. **Feed & spawn** — survivors on food eat + duplicate (atomic: no space / at cap → food stays).
4. **Pheromones** — existing markers' `ttl` −1 (gone at 0), then this turn's plants land.
5. Win check.

Practical consequences: a doomed ant can't eat first (combat resolves before feeding); planting costs a turn of movement; you can't push a friend out of their cell.

## Pheromones

- A marker = `(type 1–10, ttl)` on a cell, **one per player per cell** (replanting overwrites yours).
- **The engine gives types no meaning.** Your colony's code defines what type 3 means. Both players see all markers — signals can inform your ants, and mislead theirs.

## Limits that bite

- **Per-ant deadline (50 ms) + per-turn colony budget (1000 ms):** a slow `decide` makes that ant `wait`; once your colony's summed think-time crosses the turn budget, the REST of your ants wait too. **Design consequence: many ants must be cheap ants** — a big colony running heavy per-ant logic starves itself. Cache shared computations once per turn, or use `move_to` so the engine does the pathfinding for free. Exact limits arrive in `init`.
- **Finite food is the growth ceiling:** food never regenerates and each food = exactly one new ant, so the food map is both the battleground and the population cap. (Some leagues may add an explicit `pop_cap`; the default ladder doesn't.)
- **stderr is yours** (debug logs, shown by `aa logs`); **stdout belongs to the protocol** — the template's `log()` does the right thing.
