-- VIMTEX PLUGIN

return function()
    local g = vim.g

    g.tex_flavor = "latex"
    g.vimtex_view_method = "skim"
    g.vimtex_quickfix_mode = 0
    g.tex_conceal = "abdmg"
end
