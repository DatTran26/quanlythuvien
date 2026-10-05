# BA-Kit hooks (Windows-safe)

Do not open `.claude/hooks/*.sh`. Registries call Node:

```text
node .agents/hooks/ba-kit-run.mjs sessionStart
node .agents/hooks/ba-kit-run.mjs afterFileEdit
```

| Agent | Registry |
|---|---|
| Cursor | `.cursor/hooks.json` |
| Claude Code | `.claude/settings.json` |
| Codex | `.codex/hooks.json` |

Logic: changelog, status, stale, KG dirty-flag. `failClosed: false`.
