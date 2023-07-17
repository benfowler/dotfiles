return {
  "lervag/vimtex",
  ft = "tex",
  config = function()
    vim.jg.tex_flavor = "latex"
    vim.jg.vimtex_view_method = "skim"
    vim.jg.vimtex_quickfix_mode = 0
    vim.jg.tex_conceal = "abdmg"
  end,
}
