--Plug 'lervag/vimtex'
M.vimtex = function()
    g.tex_flavor = "latex"
    g.vimtex_view_method = "skim"
    g.vimtex_quickfix_mode = 0
    opt.conceallevel = 1
    g.tex_conceal = "abdmg"
end
