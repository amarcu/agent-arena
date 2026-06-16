# Phase: First bot

**Goal:** the player teaches their wandering ant to chase food, then beats the baseline bot — and understands every line that got them there. **Exit criteria:** ≥ 60% win rate over `sensei match --against baseline --n 20`.

> First, make sure they've actually *seen* the game — rules at their level, and a match watched together (AGENTS.md → "Start a new player in the game, not the code"). Coding before they understand what wins is the mistake this phase is built to avoid. If they walked in already knowing the game (a returning or peer player), skip ahead.

## 1. Tour the template together (short — peer mode: one sentence and the file path)

Open `bot/`'s main file with the player. It's deliberately small and readable — don't let it look intimidating. Land these and nothing else yet:

- **A read-then-print loop:** every turn the bot reads a plain-text snapshot of what this ant sees — its `turn`/`id`/position, the grid (`.` empty, `#` wall, `*` food, `?` unseen), then the nearby ants and pheromones — and prints **one command**: `MOVE`, `MOVE_TO`, `PLANT`, `MERGE`, or `WAIT` (the first bot only needs `MOVE`/`MOVE_TO`; the rest come later). No JSON, no library; the harness writes the snapshot and reads the command. The exact block is in `game-cheatsheet.md` ("Your turn").
- **You write one ant, not a colony.** Every ant runs this same program independently — "my ants" emerge from one ant's logic being good. This trips people up; land it early.
- **What it does today:** nothing clever, on purpose. It reads the whole per-turn block but **keeps none of it** — it reads the grid rows past without storing them — then just steps in a direction without looking at the board, so it bumps walls and walks past the `*` food. Two gaps there: it doesn't build a board from the input, and it doesn't use one. Ideally the player names this themselves (ask "what's it not doing with all that input?").
- Debug output goes to **stderr**; **stdout is the protocol** — anything else printed there corrupts the stream. (The starter prints nothing; if the player adds prints while debugging, send them to stderr.)

## 2. First upgrade: chase the food (the real first win)

The template reads the board and throws it away. The first upgrade has two halves — **keep** what you read, then **use** it to head for food. Coach it as a discussion, not a spec:

- **Stop discarding the grid.** As the starter reads the `height` rows, store them instead of reading past them — a list/array of strings indexes as `grid[y][x]`, or build a set of the `*` (food) coordinates. This is the "handle the input" half; designing the representation is genuinely part of the task, so let them choose.
- **Then chase the nearest `*`.** Each turn, find the closest food and go to it. "Just take the closest, no long-term plan" has a name — **greedy** — worth saying out loud once for a newer player, then moving on.
- **"Nearest" needs a measure.** On a grid with no diagonals, that's **Manhattan distance** — `|Δx| + |Δy|`, literally how many blocks you'd walk. One plain sentence; don't make it a lecture.
- **Getting there is free.** They don't have to write pathfinding: the `MOVE_TO x y` command takes a target cell and the engine walks one legal step toward it each turn, around walls, on its own. So the core is tiny — find the nearest `*`, print `MOVE_TO x y`; if there's no `*` in sight, fall back to the plain `MOVE` that's already in the file.

Let the player write it. Propose the idea, let them attempt, review what they wrote, fill gaps only on request. The moment it works, watch a replay together — ants converging on food and spawning copies is the payoff shot, and it's worth a genuine "look at that." This one step usually flips the result against `random` decisively, and often clears the baseline too.

## 3. Where to go next (the improvement ladder — rough order of payoff)

Each rung builds on the last. Don't front-load them — reach for one when the *current* bot's losses point at it, which means watching a lost replay together and naming the pattern first.

1. **Don't die:** never step onto a cell an enemy ant could also reach this turn (an enemy adjacent to the target cell). Trading one-for-one is fine *only* when you're ahead on ants.
2. **Spread out:** every ant chasing the same food wastes the colony's turns. A cheap fix needs no memory — rank your ants by distance to each food, let the closest claim it and the others take their next-best. Every ant computes the same ranking from the same board, so they agree without communicating.
3. **Don't block friends:** the engine cancels same-player move conflicts, so two ants wanting the same cell both stall — wasted turns. The spread-out logic above mostly fixes this for free.

Greedy + don't-die is usually enough to clear the 60% bar. Pick the next rung from what the replays actually show, not from this list's order.

## 4. Measure every change

```sh
sensei match --against baseline --n 20 --json
```

Quote win rates before and after each change ("vs baseline: 35% → 70% over 20 matches"). Use a fixed `--seed` while debugging one specific situation (deterministic reruns), and the `--n 20` spread to judge whether an improvement is real and not noise. But don't stop at the number and *describe* what's going wrong — open the replay and watch it together (`sensei replay latest`, lost replays first), the same turn you report the result. The win rate says a change regressed; the replay is where the player actually sees why their ants clump or die. Showing beats telling — proactively, not when they ask (see AGENTS.md → "Show the game, don't just narrate it").

## Common first-bot failures

- **Timeouts:** each turn has a per-ant deadline (a few ms). Using `MOVE_TO` keeps the first bot well clear of it; the risk shows up later, e.g. scanning for nearest food per-ant-per-turn on a big board without caching. `sensei log` shows per-call timing.
- **Invalid commands** (the engine treats them as `WAIT`): usually a typo'd command or a missing argument, or accidentally printing something to stdout that isn't a command — check "Your turn" in `game-cheatsheet.md` and keep debug on stderr.
- **Falling out of sync:** the bot must read the *whole* per-turn block — every grid row, every ant and pheromone line — before printing its command, or the next turn's read is misaligned. The starter already reads past the parts it doesn't use; keep that.
- **The ant-mill:** ants oscillating A→B→A forever. Stateless ants can't remember they just came from B — break ties deterministically (prefer the direction that reduces distance; on exact ties, order N>E>S>W by `ant_id` parity so two ants tie-break differently).

When the exit criteria is met, mark the moment in the register you're in — mentor mode: congratulate them properly, beating the baseline is the platform's "it compiles and it *thinks*" moment; peer mode: "baseline's dead — ladder?" Then go to `.agents/03-submit-and-climb.md`.
