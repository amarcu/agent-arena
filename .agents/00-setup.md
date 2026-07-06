# Phase: Setup

**Goal:** working `sensei` CLI + a scaffolded bot in the player's language + the working habits armed. **Exit criteria:** `sensei match --against random` completes, the player has watched the replay, and the repo is a git repo with a first commit.

(Peer mode: this whole phase compresses to four commands — install, `sensei init`, `git init`, `sensei match` — narrate nothing unless something breaks.)

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

## 3. Scaffold + arm the habits

```sh
sensei init --lang <choice>
git init
git add -A
git commit -m "starter template, untouched"
```

(Separate lines on purpose — `&&` chaining is a syntax error in Windows PowerShell 5.)

`sensei init` creates `bot/` from the official starter: a deliberately naive bot that reads the whole per-turn input but **keeps none of it**, then steps in a direction without looking at the board. Building a board from the input, then chasing food, is the first bot's job — don't fix it now. `sensei init` is idempotent and refuses to overwrite an edited `bot/`.

The `git init` matters more than it looks: **from here on, commit before every experiment, message = the hypothesis** ("greedy targeting should beat wandering"). In a later phase the player will hit a regression they can't explain, and the commit history becomes the debugging tool (`git bisect`) — that lesson only works if the habit starts now. Also create an empty `JOURNAL.md` at the repo root — one 3-line entry per kept change (*Change / Why + expected / Measured*) starts next phase.

## 4. Verify (the smoke test)

```sh
sensei match --against random --seed 1
```

If this completes, the whole chain works: toolchain → bot process → embedded referee → replay. Before opening the replay, get one prediction: *"what do you think your ant will do?"* Then `sensei replay latest` **with the player watching** — seeing their ants move, even badly, is the hook. Don't lecture over it; compare what happened to their prediction and ask what they notice. The ants wander right past food without eating — that gap *is* the first bot's job, and a natural bridge into `.agents/01-first-bot.md`.

## If it fails

- `sensei doctor` again — most failures are a missing toolchain (no `python3` on PATH, etc.); it names the fix.
- Bot crashed on turn 1 → `sensei log` shows the stderr traceback.
- Corporate proxy / no network for the install → the binary can be downloaded manually from the releases page; everything after install is offline.
