# Agent Sensei — build a bot for Ant Wars

> Build a bot **with your AI agent**, watch it fight, and climb a live ladder.

Agent Sensei is a programming competition built for how developers actually work now: you and the coding agent of your choice — Claude Code, Cursor, Codex, … — build a bot *together*, then it competes bot-vs-bot on a continuous ladder. This repo is your workspace. Clone it, open it in your agent, and say **"get me started."**

**▶ Watch live matches & read the game:** **[agentsensei.dev/c/ant-wars](https://agentsensei.dev/c/ant-wars)** · **Ladder:** [agentsensei.dev/leaderboard](https://agentsensei.dev/leaderboard)

---

## The game — Ant Wars

A 1v1 on a seeded, symmetric grid, under **fog of war**. You write the logic for **one ant** — and every ant in your colony runs that same program independently. There is no "command all my ants" call; coordination is emergent. Each decision sees the colony's **shared** sight — the union of what all your living ants can see (still fogged), so scattering scouts widens what the whole colony perceives.

- 🐜 **Eat to multiply** — an ant that ends its turn on food spawns a **level-1** child on the next cell. Breeding never inherits power; it always starts fresh at level 1.
- ⚔️ **Collide to kill** — when enemy ants meet (share a cell, or swap through each other) the **higher level survives**, keeping its power; **equal levels both die**. A level-3 ant walks through level-1s untouched.
- 💪 **Level up by merging** — every ant has a level (power, starting at 1). `MERGE` fuses an ant into an adjacent ally, **summing** their levels into one stronger ant. A fused giant is mightier but still counts as **one ant** at scoring — so stacking trades numbers for muscle.
- 🧪 **Talk in pheromones** — drop markers (type 1–10, *meaning is yours to define*) that **both** colonies can see. Your only channel to coordinate your ants — and to bluff the enemy's.
- 🏆 **Win** — hold the most ants at turn ~200, or wipe the other colony out first. (A fused high-level ant counts as one, so out-numbering can beat out-muscling.)

Each turn your program reads a **plain-text** snapshot of what the colony can see and prints **one** command — CodinGame-style, no JSON:

```
MOVE N|E|S|W      step one cell
MOVE_TO x y       the engine pathfinds one step toward (x,y) for you
PLANT type ttl    drop a pheromone on your cell
MERGE N|E|S|W     fuse into the adjacent ally there (your levels add)
WAIT              do nothing
```

Full spec + the exact I/O block: **[.agents/game-cheatsheet.md](.agents/game-cheatsheet.md)**.

---

## Quickstart

### The intended way — with your agent
Open this folder in your AI agent and say **"get me started."** It reads [AGENTS.md](AGENTS.md) and coaches you from zero to a ranked bot — picking a language with you, scaffolding a bot, running local matches you watch together, and explaining the game as you go. No prior game knowledge needed.

### Or by hand

**1. Install the `sensei` CLI** (one binary, no dependencies):

- **macOS / Linux**
  ```sh
  curl -fsSL https://get.agentsensei.dev | sh
  ```
- **Windows** (PowerShell)
  ```powershell
  irm https://get.agentsensei.dev/win | iex
  ```
- **From source** (any platform with Rust) — clone the [platform repo](https://github.com/amarcu/agent-arena-platform) and, from its `engine/` directory:
  ```sh
  cargo build --release -p arena-cli
  ```

**2. Build, play, and climb:**

```sh
sensei init --lang python        # scaffold a starter bot — also: typescript | go | rust | cpp
sensei match --against baseline  # play a local match and open the replay
# ...edit bot/ until you beat the baseline...
sensei login                     # sign in (opens your browser)
sensei submit                    # put your bot on the ladder
```

Handy: `sensei doctor` checks your setup (language toolchains, editors, and whether the ladder is up) · `sensei rules` prints the full engine rules (`--code` emits the referee source) · `sensei help` lists every command · `sensei replay latest` re-opens your last match.

> **No account needed to build and play** — everything local runs against an embedded referee that's byte-identical to the server's. You only sign in when you're ready to submit.

---

## What's in this repo

| Path | What it is |
|---|---|
| [AGENTS.md](AGENTS.md) | The coaching protocol your AI agent reads to guide you. |
| [.agents/](.agents/) | Step-by-step phase guides + the [game cheatsheet](.agents/game-cheatsheet.md). |
| [.agents/skills/](.agents/skills/) | Coaching rituals (loss review, pre-submit gauntlet, boss postmortem) — cross-agent [skills](https://agentskills.io); mirrored in `.claude/skills/` for Claude Code. |
| `bot/` | Your bot, created by `sensei init`. It stays on your machine — `sensei submit` uploads only the build artifact. |
| `JOURNAL.md` | Your engineering log, one 3-line entry per kept change — your agent drafts it, you confirm it. |

> **Effort stats (opt-in):** `sensei` can attach a self-reported "built with N tokens" summary to your submissions — aggregate token/model stats read from your agents' local logs, never conversation content. You'll be asked once at submit; `sensei stats show` prints the exact payload, `sensei stats disable` turns it off.

---

## How it works

You iterate locally against an embedded referee that is the *same code* the server runs, so what you see locally is exactly what runs ranked — no drift. When you submit, your bot plays fog-of-war matches against other players on our infrastructure, an ELO-style rating settles, and **every game is replayable**. Climb at **[agentsensei.dev](https://agentsensei.dev)**.
