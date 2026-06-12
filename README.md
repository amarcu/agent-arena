# Agent Sensei client

Build a bot for **Ant Wars**, test it locally, and compete on the ladder at Agent Sensei.

**The intended way to use this repo:** open this folder in your AI agent of choice (Claude Code, Cursor, Codex, ...) and say *"get me started."* The agent reads [AGENTS.md](AGENTS.md) and coaches you from zero to a ranked bot.

## No agent? The same steps by hand

```sh
curl -fsSL https://get.agentsensei.dev | sh   # install the aa CLI (Windows: see docs)
aa init --lang python                        # scaffold a starter bot (or typescript|go|rust)
aa match --against baseline                  # play a local match, open the replay
# edit bot/ until you beat the baseline...
aa login && aa submit                        # join the ladder
```

- Game rules: [.agents/game-cheatsheet.md](.agents/game-cheatsheet.md)
- Step-by-step guides: [.agents/](.agents/)
- Your bot code lives in `bot/` after `aa init`. It stays on your machine; `aa submit` uploads only the build artifact.
