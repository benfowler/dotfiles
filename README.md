# dotfiles: Ben's public dotfiles

![Screenshot of Neovim with Ammonite (Scala) scripts, tmux](screenshot.jp2)

## What's here?

### Neovim

Nord-themed, super-clean Neovim configuration.  Intended to keep keybindings as
'standard' as possible to keep everything aligned with the VS Code and IntelliJ
Vim plugins, but be usable for productive scripting.

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
- **Advanced, IDE-like LSP-powered code folding support** (off by default).
  Uses [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo), but **be warned, it requires a** [Neovim C source hack](https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1157722074) **to work
  correctly**:

```diff
diff --git a/src/nvim/screen.c b/src/nvim/screen.c
index 2ee7cd44f..8982bd2ee 100644
--- a/src/nvim/screen.c
+++ b/src/nvim/screen.c
@@ -1931,12 +1931,8 @@ static size_t fill_foldcolumn(char_u *p, win_T *wp, foldinfo_T foldinfo, linenr_
     if (foldinfo.fi_lnum == lnum
         && first_level + i >= foldinfo.fi_low_level) {
       symbol = wp->w_p_fcs_chars.foldopen;
-    } else if (first_level == 1) {
-      symbol = wp->w_p_fcs_chars.foldsep;
-    } else if (first_level + i <= 9) {
-      symbol = '0' + first_level + i;
     } else {
-      symbol = '>';
+      symbol = wp->w_p_fcs_chars.foldsep;
     }

     len = utf_char2bytes(symbol, (char *)&p[char_counter]);
```

#### To Do

- Port remaining Vim-isms to Lua
- Find a way to change signs in the sign column _by buffer_ rather than
  globally as now.  My Git change indicators change depending on whether or not
  folding is enabled, but this limitation makes them look wrong when some
  windows have folding enabled, but others don't.  **Ideally, Neovim would
  support pluggable strategies for sign placement**, but I don't see that
  happening any time soon.
- Break dependency on the Vim Nord theme, port the theme configuration to the
  excellent [lush.nvim](https://github.com/rktjmp/lush.nvim), and make colorschemes _and_ background color switchable
  _and_ sticky.

