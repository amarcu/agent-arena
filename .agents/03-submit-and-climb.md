# Phase: Submit & the ladder

**Goal:** the bot is on the public ladder with a stable rating, via the gauntlet — never raw. **Exit criteria:** rating visible on the leaderboard; player knows how to read their match history and what gates their promotion.

## 1. Account (player-run)

`sensei login` — opens the browser for OAuth. **The player runs this themselves** (it's their account). First time also creates their profile at the site.

## 2. The gauntlet, then submit

Every submission goes through the gauntlet — `.agents/skills/pre-submit-gauntlet/SKILL.md` owns the gates (a first submission skips only the self-play gate; there's nothing to self-play against yet).

What happens after `submit`, so you can narrate it: local smoke test (catches "works here, breaks there" before upload) → tar + upload → server builds the official image (build log streams back; failures show here, not in ranked matches) → **bootstrap burst** of placement matches. The bot appears on the leaderboard once its rating uncertainty tightens — minutes, not instantly; `sensei status` tracks it. Rating starts conservative and *rises as it proves out* — say this up front so the first hour doesn't read as failure.

Each submission is a separate rated bot; the player's best live bot represents them. Submitting is cheap — encourage it whenever a change survives the gauntlet.

## 3. Reading the ladder

- **Leagues & bosses:** Wood → Bronze → Silver (more coming). Promotion = beat the league's **boss** — Genghis Ant gates Wood, Sun Tz-ant gates Bronze. No demotion, ever. The matchmaker schedules boss challenges when the bot is ready; a lone new bot calibrates against its boss automatically.
- **Bosses are exams:** each one punishes a specific weakness (Genghis: threat-blindness; Sun Tz-ant: bad trades). Every attempt — win or lose — gets the ritual in `.agents/skills/boss-postmortem/SKILL.md`: watch the boss's replay, 3-up/3-down postmortem into `JOURNAL.md`, and on a win the mastery check — the player explains the winning mechanism before the promotion "counts" as learning. Losing to a boss the first time is the intended experience.
- Ladder losses are iteration fuel: `sensei status` lists recent matches; pull lost replays into the `.agents/02-iterate.md` loop.

## Rules of play (the short honest version)

- Bots run sandboxed: **no network, no filesystem** beyond scratch, fixed CPU/memory. Don't design around outside resources.
- **One ant, one decision.** Each decision answers for *its* ant from the shared board state. A hidden central planner that computes all ants' moves jointly is against the spirit and the rules; pheromones are the sanctioned coordination channel — use them well instead.
- AI-written code is not cheating — it's the point of the platform. Sandbagging (deliberately tanking rating) and exploiting the matchmaker are.
