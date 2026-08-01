# neovim

Minimal Neovim configuration managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

## Setup

`~/.config/nvim` is **not** a single symlink — individual subdirectories and
files are symlinked into this repo. `lazy-lock.json` is also symlinked:

```sh
ln -s ~/Repos/github.com/benfowler/dotfiles/neovim/lazy-lock.json ~/.config/nvim/lazy-lock.json
```

## Development tooling

This project uses [mise](https://mise.jdx.dev/) to manage tool versions and tasks.

```sh
mise install   # install pinned tool versions (stylua, luacheck)
```

### Tasks

| Task | Description |
|------|-------------|
| `mise run fmt` | Format all Lua files with StyLua |
| `mise run fmt-check` | Check formatting without modifying files |
| `mise run lint` | Lint Lua files with luacheck |
| `mise run smoke` | Headless Neovim startup smoke test |

## Plugin lockfile

`lazy-lock.json` records the exact commit SHA of every installed plugin.
It is committed to this repo so all machines run identical plugin versions.

### Workflow

**Deliberate update:**
```sh
# Inside Neovim:
:Lazy update

# Then in the shell:
git diff neovim/lazy-lock.json   # review what changed
git add neovim/lazy-lock.json
git commit -m "neovim: bump plugins"
```

**Roll back a broken update:**
```sh
git checkout HEAD~1 -- neovim/lazy-lock.json

# Inside Neovim:
:Lazy restore
```
