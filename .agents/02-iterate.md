# Phase: Iterate & climb

**Goal:** a repeatable improvement loop the player drives. This phase never "exits" — it's the game. Your job shifts from teacher to engineering partner.

## The loop (make it a ritual)

1. **Watch losses.** Pull 2–3 lost replays from the ladder (or local self-play). Name the *pattern* of the loss, not the moment ("we lose food races on the right flank," not "turn 41 was bad").
2. **One hypothesis, one change.** Smallest edit that addresses the pattern.
3. **Measure:** `sensei match --against baseline --n 20 --json` *and* self-play vs the previous version — `sensei match --against <path-to-old-bot> --n 20`. Keep the old version around (suggest the player commit before each experiment; this is a good habit to model anyway).
4. **Keep or revert based on the number, not the vibe.** Then submit when a change survives both gauntlets: `sensei submit`.

## Strategy ladder (rough order of returns)

- **Opening:** the first 30 turns decide the food split. Expand toward the *contested* middle food early; safe corner food will still be there later.
- **Population arithmetic:** every trade is fine when ahead, bad when behind. `len(my_ants) - len(enemy_ants)` should gate aggression globally — every ant computes it from the same state, so the colony shifts mood together without communication.
- **Pheromones as shared memory:** stateless ants forget; the board doesn't. Ideas players discover here: plant type-1 on exhausted food zones ("don't bother"), type-2 as a rally/attack beacon, type-3 trail markers to suppress ant-mills. The *meaning* is yours — the engine assigns none. Remember the enemy reads them too: fake beacons are legal and delightful.
- **Endgame clock:** at turn 300 the bigger colony wins. Ahead near the cap → stop fighting, scatter and survive. Behind → you *must* force trades or food. The turn number is in the state; use it.
- **Counter-meta:** watch ladder replays of the bots directly above you and tune against what they actually do.

## Teach the co-agent meta here (mentor mode — this is where it lands)

The player is now doing real engineering. Make the habits explicit when they bite (peers: skip the framing, just practice these together):
- Small diffs beat rewrites — a 200-line "smarter" rewrite that drops the win rate is the lesson, let it happen once.
- Have the player explain *your* suggestion back before applying it; if they can't, simplify it.
- Data over plausibility — "it should be better" loses to 20 matches that say it isn't.
- Version everything — being able to fight your yesterday-self is the fastest progress signal on the platform.
