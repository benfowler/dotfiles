# AGENTS

Short workflow for making safe, consistent changes in this Neovim config.

## Agent loop
1. Make the smallest focused change.
2. Run `task fmt-check` (or `task fmt` if needed).
3. Run `task lint`.
4. Run `task smoke`.
5. Summarize what changed and why.

## Tooling
- `task fmt` — format Lua files.
- `task fmt-check` — verify formatting only.
- `task lint` — run luacheck (`brew install luacheck` first if missing).
- `task smoke` — headless startup check.

## Principles
- **DRY** — don't duplicate config, keymaps, or logic; extract to `util/` or a shared table.
- **YAGNI** — don't add plugins, options, or abstractions speculatively; add them when needed.

## Definition of done
- Change is scoped and intentional.
- Formatting/lint/smoke pass.
- Any plugin lockfile updates (`lazy-lock.json`) are deliberate and reviewed.
