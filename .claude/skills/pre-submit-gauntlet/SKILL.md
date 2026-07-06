---
name: pre-submit-gauntlet
description: Pre-submission checklist for putting an Ant Wars bot on the public ladder. Use whenever the player wants to run sensei submit, says the bot is ready, or asks to publish or update their ladder bot. Enforces beating the previous version over fixed seeds before submitting.
---

# Pre-submit gauntlet — never ship a regression

The ladder measures slowly and publicly; the gauntlet measures now and
privately. Engines like Stockfish accept no patch without beating the previous
version — same idea, bot-sized.

If this is the session's first exchange, run the AGENTS.md session start
first — `sensei status --json`, profile — then the gauntlet.

## The gauntlet

1. **Baseline gate:** `sensei match --against baseline --n 20 --json` — the
   win rate holds or beats the last journal entry.
2. **Self-play gate:** the candidate beats the bot you last submitted.
   Keep the previous version runnable *inside the repo* — copy `bot/` to
   `bot-prev/` before each submission (or check out the `submitted-N` tag
   into a folder in-repo) — then pass its run command as the opponent:
   `sensei match --against "python bot-prev/main.py" --n 20` (adjust for the
   language). **First submission: there is no previous version — skip this
   gate; the baseline gate and seed check are the whole gauntlet.**
3. **Fixed-seed spot check:** rerun the 2–3 seeds whose failure patterns you
   fixed — their numbers are in `JOURNAL.md` Measured lines. These seeds are
   the regression suite; matches are the tests.
4. **Journal + tag:** one entry for what this submission changes and what you
   expect the rating to do; tag the commit (`submitted-N`).
5. **Confirm, then submit:** submitting publishes to the public ladder —
   confirm the player is ready, then `sensei submit` and narrate the pipeline
   as it streams (the stages are described in `.agents/03-submit-and-climb.md`).

If a gate fails: that's the gauntlet working. Back to the loss-review ritual
with the seed or matchup that failed — the ladder never sees it.

## Register notes

- Mentor: the first submission is a milestone — walk the pipeline once so they
  know where build failures would surface (`sensei submit` streams the build
  log). Celebrate when it lands.
- Peer: run the gates, quote three numbers, ship. "Placement takes minutes,
  not seconds" is still worth one sentence.
