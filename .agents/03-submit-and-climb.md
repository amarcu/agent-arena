# Phase: Submit & the ladder

**Goal:** the bot is on the public ladder with a stable rating. **Exit criteria:** rating visible on the leaderboard; player knows how to read their match history.

## 1. Account (player-run)

`sensei login` — opens the browser for OAuth. **The player runs this themselves** (it's their account). First time also creates their profile at the site.

## 2. Submit (player-confirmed)

Confirm they're ready ("this puts your bot on the public ladder"), then:

```sh
sensei submit
```

What happens, so you can narrate it:
1. Local smoke test (a quick match vs a stub — catches "works here, breaks there" before upload).
2. Tar + upload; the server builds the bot into the official image (build log streams back; build failures show here, not in ranked matches).
3. **Bootstrap burst:** ~30 placement matches against a spread of opponents. The bot appears on the leaderboard once its rating uncertainty tightens — typically minutes, not instantly. `sensei status` tracks it.

Each submission is a separate rated bot; the player's best live bot represents them. Submitting is cheap — encourage it whenever local numbers improve.

## 3. Reading the ladder

- **Rating is conservative** (skill estimate minus uncertainty): new bots start low and *rise as they prove out* — tell the player this up front so the first hour doesn't feel like failure.
- **Leagues:** Wood → Bronze → Silver → Gold. Promotion = beat the league's **boss bot**. No demotion, ever — a promotion is permanently yours.
- Losses on the ladder are the iteration fuel: `sensei status` lists recent matches; pull lost replays into the `.agents/02-iterate.md` loop.

## Rules of play (the short honest version)

- Bots run sandboxed: **no network, no filesystem** beyond scratch, fixed CPU/memory. Don't design around outside resources.
- **One ant, one decision.** The game's whole premise is decentralized ants — each `decide` call answers for *its* ant from the shared board state. Building a hidden central planner that computes all ants' moves jointly is against the spirit and the rules of the competition, and league play is tuned to make honest colonies competitive. Pheromones are the sanctioned way to coordinate — use them well instead.
- AI-written code is not cheating — it's the point of the platform. Sandbagging (deliberately tanking rating) and exploiting the matchmaker are.
