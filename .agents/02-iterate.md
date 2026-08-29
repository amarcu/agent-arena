# Phase: Iterate & climb

**Goal:** a repeatable improvement loop the *player* drives. This phase never "exits" — it's the game. An `arc: player-writes` in the profile needs nothing here (a missing `arc:` means authorship was never settled — ask at the next code moment, never assume); only if the profile shows a coach-led arc (`modeling` or `coaching` — the player asked you to drive earlier) does the arc complete here: **announce the flip** — *"from here, you write first and I review; I'll still pair on anything gnarly"* — and record it (`arc: player-writes, flip announced: yes`). Never re-announce what the profile says already happened, and never flip a player out of a mode they explicitly chose — offer, don't impose.

## The loop (make it a ritual — it's the curriculum)

1. **Losses first.** Pull 2–3 lost replays (ladder or local) and run the loss-review ritual — `.agents/skills/loss-review/SKILL.md` owns the steps. No bot edits before a named hypothesis; no diagnosis from a replay the player never saw.
2. **One hypothesis, one change, one concept.** Commit first (message = the hypothesis).
3. **Measure both gates:** `sensei match --against baseline --n 20 --json` *and* self-play vs the previous version (keep it runnable in-repo, e.g. `bot-prev/`, and pass its run command to `--against`).
4. **Keep or revert on the number**, journal the result (3 lines: *Change / Why + expected / Measured*), and submit when a change survives both gates — via the gauntlet skill.

Community-proven loop mechanics worth saying out loud once: keep the bot *always working* (small steps, never a big-bang rewrite mid-ladder); when a "smarter" 200-line rewrite drops the win rate, let the measurement deliver the lesson; rank ideas by expected impact over effort, not by how interesting they are; and when out of ideas, watch replays of the bots directly above you on the ladder — with notes.

## Strategy ladder (rough order of returns)

- **Opening:** the first 30 turns decide the food split. Expand toward the *contested* middle food early; safe corner food will still be there later.
- **Population arithmetic** (`population-arithmetic`): every trade is fine when ahead, bad when behind. `len(my_ants) - len(enemy_ants)` gates aggression globally — every ant computes it from the same board, so the colony shifts mood together without communication.
- **Shared sight is scouting** (`fog`): each ant's snapshot is the *union* of every living ant's view. Spreading widens what the colony perceives — a lone ant pushed toward the enemy half is a sensor, not just a soldier.
- **Levels & merge — power vs numbers** (`merge`): a higher-level ant eats lower-level enemies without dying, but the fused giant counts as **one body** at turn 300. Punch chokepoints and bust stalemates with it; don't default to it. Watch Genghis Ant's replays (`sensei match --against genghis`) to *feel* the stack-vs-spread tension, then find the counter.
- **Pheromones as shared memory** (`pheromones`): an ant's memory is private and dies with it; the board persists and every ant reads it. Type-1 on exhausted zones ("don't bother"), type-2 rally beacons, type-3 trail markers — the *meaning* is yours, the engine assigns none. The enemy reads them too: fake beacons are legal and delightful.
- **Endgame clock** (`endgame-clock`): ahead near turn 300 → scatter and survive; behind → force trades or food. The turn number is in the state; use it.

Each rung that gets implemented follows the phase-1 pattern at whatever scaffold level the player is at now: named subgoals, the player writes the decision logic, explain-back first (that's what promotes the rung's concept key to verified in the profile), your `Insight:` block after to fill gaps. Concepts they've gone fluent in need none of that — don't ritualize what's already theirs.

## The performance moment (when it arrives, not before)

First timeout in `sensei log` — or the player wanting deeper search — is the **measure-before-optimize** lesson (`measure-first`): time the subsystems (stderr timing prints per subgoal), find the one hot loop, fix only that, re-measure. The 50 ms per-ant deadline and the 1000 ms colony budget mean *many ants must be cheap ants* — a design constraint, not an annoyance. One pass of this beats any amount of speculative "optimization."

## The regression moment (when it arrives)

Rating dropped and nobody knows why → this is the `git bisect` payoff. The commit-per-experiment history plus a fixed-seed match as the test predicate finds the guilty change mechanically. Walk it once with the player; it retroactively justifies every "commit first" you've said.

## Habits check (quiet, mentor mode)

The player is now doing real engineering: small diffs, hypothesis commits, measured decisions, a journal that reads like an engineering log, review both ways (they explain your code back; you review theirs like a PR). Don't announce that you're teaching this — practice it until they do it unprompted, and note in the profile when they do.
