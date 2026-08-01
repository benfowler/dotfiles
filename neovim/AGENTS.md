# AGENTS

Short workflow for making safe, consistent changes in this Neovim config.

## Agent loop
1. Make the smallest focused change.
2. Run `mise run fmt-check` (or `mise run fmt` if needed).
3. Run `mise run lint`.
4. Run `mise run smoke`.
5. Summarize what changed and why.

## Tooling
- `mise install` — install pinned tools (StyLua).
- `mise run fmt` — format Lua files.
- `mise run fmt-check` — verify formatting only.
- `mise run lint` — run luacheck (`brew install luacheck` first if missing).
- `mise run smoke` — headless startup check.

## Principles
- **DRY** — don't duplicate config, keymaps, or logic; extract to `util/` or a shared table.
- **YAGNI** — don't add plugins, options, or abstractions speculatively; add them when needed.

## Definition of done
- Change is scoped and intentional.
- Formatting/lint/smoke pass.
- Any plugin lockfile updates (`lazy-lock.json`) are deliberate and reviewed.
