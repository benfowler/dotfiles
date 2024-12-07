# dotfiles: Ben's public dotfiles

## What's here?

### Neovim

OneDark-themed, super-clean Neovim configuration.  Intended to keep keybindings
as 'standard' as possible to keep everything aligned with the VS Code and
IntelliJ Vim plugins, but be usable for productive scripting.

**New and noteworthy**:

- **Don't use tabline**.  I find listing open buffers as fake 'tabs' to be
  confusing, so I don't bother with it.  I just use `fzf` and `Ctrl-O` to
  rapidly switch between buffers.
- **Use a hand-written statusline**.  It's easy to do, so I built one tailored
  exactly to my own needs.
- **Use the new Neovim winbar**.  I put the filename and a file-specific LSP
  diagnostic indicator on the top-right, so I can see the health of the current
  file (as opposed to workspace) in the top-right corner of each window.
- **Expose LSP CodeLenses with signs and virtual text**.  Note that this relies
  on overriding Lua functions in the Neovim LSP implementation and hence may be
  brittle; but it works for me at this time.

> [!WARNING]
> **BUGS**: certain aspects of this configuration have degraded over time.
> Telescope -- never a completely stable thing -- is doing numerous strange
> things with keyboard handling.  Markdown editing, too, has gotten notably more
> buggy lately.  Indentation of bullets, especially, needs to be tested and
> debugged.
