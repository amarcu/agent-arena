# Agent Sensei client

Build a bot for **Ant Wars**, test it locally, and compete on the ladder at Agent Sensei.

**The intended way to use this repo:** open this folder in your AI agent of choice (Claude Code, Cursor, Codex, ...) and say *"get me started."* The agent reads [AGENTS.md](AGENTS.md) and coaches you from zero to a ranked bot.

## No agent? The same steps by hand

```sh
curl -fsSL https://get.agentsensei.dev | sh   # install the sensei CLI (Windows: see docs)
sensei init --lang python                        # scaffold a starter bot (or typescript|go|rust)
sensei match --against baseline                  # play a local match, open the replay
# edit bot/ until you beat the baseline...
sensei login && sensei submit                        # join the ladder
```

- Game rules: [.agents/game-cheatsheet.md](.agents/game-cheatsheet.md)
- Step-by-step guides: [.agents/](.agents/)
- Your bot code lives in `bot/` after `sensei init`. It stays on your machine; `sensei submit` uploads only the build artifact.
