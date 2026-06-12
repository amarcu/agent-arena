# Phase: First bot

**Goal:** the player understands the template and beats the baseline bot. **Exit criteria:** ≥ 60% win rate over `aa match --against baseline --n 20`.

## 1. Tour the template (5 minutes, not 30 — in peer mode, one sentence and the file path)

Open the bot's main file with the player. The only thing that matters:

```
decide(state, ant_id) -> action
```

Called once per living ant per turn. `state` is the whole board (walls, food, every ant, every pheromone); `ant_id` is *this* ant. Return move / plant / wait. The harness handles all wire-format details. Debug printing goes to **stderr** (the template's `log()` helper) — never stdout.

Key mental model to land early: **you are not writing a colony commander.** Every ant runs this same function independently. "My ants" emerge from one ant's logic being good.

## 2. The improvement ladder (in order — each beats the previous)

1. **Greedy food:** move toward the nearest food (BFS/Manhattan around walls). This alone usually beats `random` decisively.
2. **Don't die:** never step onto a cell an enemy ant could also reach this turn (enemy adjacent to the target cell). Trading 1-for-1 is fine *only* when ahead on ants.
3. **Spread out:** all ants chasing the same food wastes turns. Cheap fix without memory: rank ants by distance to each food; let the closest ant claim it, others pick their next-best. (Every ant computes the same ranking from the same state — so they agree without talking.)
4. **Don't block friends:** the engine cancels same-player move conflicts — colliding intentions = wasted turns. The spread logic above mostly fixes this.

Step 1 → 2 is usually enough to beat the baseline. Let the player implement; review their attempt; fill gaps on request.

## 3. Measure every change

```sh
aa match --against baseline --n 20 --json
```

Quote win rates before/after each change. Use a fixed `--seed` while debugging a specific situation (deterministic reruns), and the `--n 20` spread to judge real improvement. Watch a *lost* replay together when stuck — losses teach more than wins.

## Common first-bot failures

- **Timeouts:** `decide` has a per-ant deadline (a few ms). BFS over a 30×30 grid is fine; BFS *per food per ant per turn* without caching may not be. `aa logs` shows per-call timing.
- **Invalid actions** (engine warns, treats as `wait`): usually a malformed direction or planting with a bad TTL — check shapes in `game-cheatsheet.md`.
- **The ant-mill:** ants oscillating A→B→A forever. Stateless ants can't "remember" they just came from B — break ties deterministically (e.g., prefer the direction that reduces distance; on exact ties, order N>E>S>W by `ant_id` parity so two ants tie-break differently).

When the exit criteria is met, mark the moment in the register you're in — mentor mode: congratulate them properly, beating the baseline is the platform's "it compiles and it *thinks*" moment; peer mode: "baseline's dead — ladder?" Then go to `.agents/03-submit-and-climb.md`.
