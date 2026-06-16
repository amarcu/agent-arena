# Phase: Setup

**Goal:** working `sensei` CLI + a scaffolded bot in the player's language. **Exit criteria:** `sensei match --against random` completes and the player has watched the replay.

(Peer mode: this whole phase compresses to three commands — install, `sensei init`, `sensei match` — narrate nothing unless something breaks.)

## 1. Install the CLI (if `sensei` is missing)

Show the player the command and get a yes before running it:
- macOS / Linux: `curl -fsSL https://get.agentsensei.dev | sh`
- Windows (PowerShell): `irm https://get.agentsensei.dev/win | iex`

Then `sensei doctor` — it checks the binary, OS/arch, and which language toolchains are present. Fix what it flags before moving on (it prints the fix command for each finding). No account/login is needed in this phase — anyone can play locally.

## 2. Choose the language

Use the player's answer from the profile probe:
- **New to programming / knows a little Python** → `python` (default recommendation).
- **Web developer** → `typescript`.
- **Knows Go or Rust** → that. Don't talk a beginner into a systems language for "performance" — strategy beats speed at every league below Gold.
- **Competitive-programming background** → `cpp` (the I/O is exactly the algo-problem style they know — `cin`/`cout`, no libraries).
- Some other language they love → possible via the custom Dockerfile tier, but steer first-timers to the four templates; the custom path has no training wheels.

## 3. Scaffold

```sh
sensei init --lang <choice>
```

Creates `bot/` from the official starter template: a deliberately naive bot that reads the whole per-turn input but **keeps none of it**, then just steps in a direction without looking at the board (so it bumps walls and walks past food). Building a board from the input rows, then chasing food, is the first bot's job. The I/O is plain text — read a snapshot of what the ant sees each turn, print one command (`MOVE`/`MOVE_TO`/`PLANT`/`MERGE`/`WAIT`); no JSON, no libraries, the harness handles the wire protocol. Plus an `agent-arena.toml` manifest. The starter is short and readable on purpose — open it with the player, don't let it intimidate. `sensei init` is idempotent and refuses to overwrite an edited `bot/` — if the player wants to switch languages later, have them confirm explicitly.

## 4. Verify (the smoke test)

```sh
sensei match --against random --seed 1
```

If this completes, the whole chain works: toolchain → bot process → embedded referee → replay. Open the replay (`sensei replay latest`) **with the player watching** — seeing their ants move, even badly, is the hook. Don't lecture over it; ask what they notice. The ants wander right past food without ever eating — that gap *is* the first bot's job, and it makes a natural bridge into `.agents/01-first-bot.md`.

## If it fails

- `sensei doctor` again — most failures are a missing toolchain (no `python3` on PATH, etc.); it names the fix.
- Bot crashed on turn 1 → `sensei log` shows the stderr traceback.
- Corporate proxy / no network for the install → the binary can be downloaded manually from the releases page; everything after install is offline.
