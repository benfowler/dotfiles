# Ben's Neovim 0.5+ Lua Config

**A personal Neovim configuration built from
[NvChad](https://nvchad.netlify.app/).**

This configuration, rather than _using_ NvChad, treats it like a project
starter, but loses the genericity in favour of even greater simplicity.

This approach works because NvChad is already pretty simple -- and besides --
the _entire point_ of (Neo)vim is its flexibility and customisability, and
simply using an off-the-shelf script cuts against the grain.

## Why bother?

**In one word -- _speed_**.

- On my machine, my old configuration took about 370 ms to load -- slow enough
  to be annoying
- In comparison, Neovim nightly built, from a warm start, takes **50 ms** to
  start
- Neovim running NvChad takes a mere **67 ms**!!  I think I can match this,
  while still running a full set of plugins for light development in many
  languages _and without the need for a lightweight alternative configuration
  for Vim edit mode in zsh!_

To achieve this, we do several things:

- Use Packer instead of vim-plug
- Disable built-in plugins we never use
- Use Lua-based plugins wherever possible.  Neovim Lua scripters seem obsessed
  with performance.
- Like NvChad, lazy-load as much as possible

## Install

```bash
git clone https://github.com/benfowler/neovim-config ~/.config/nvim
nvim +PackerSync
```

## Update

```vimscript
<Leader> uu
```

## Uninstall

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
```
