local g = vim.g
local cmd = vim.cmd


-- Utility method to make setting highlights not suck
function hi(group, opts)
	local c = "highlight " .. group
	for k, v in pairs(opts) do
		c = c .. " " .. k .. "=" .. v
	end
	vim.cmd(c)
end


-- Theme-agnostic setup
function my_highlights_all()

   -- Transparent background, including signcolumn and foldcolumn, but not linenr
    hi("Normal", { guibg="NONE", ctermbg="NONE" })
    hi("SignColumn", { guibg="NONE", ctermbg="NONE" })
    hi("FoldColumn", { guibg="NONE", ctermbg="NONE" })
end


-- Nord-specific setup
function my_highlights_nord()

    -- (poor readability of some highlight groups)
    -- (Stock fg was: guifg=nord3_gui, ctermfg=nord3_term)
    hi("SpecialKey", { guifg="#616E88", ctermfg=8 })

    -- (Stock fg was: guifg=nord2_gui, gui=bold, ctermfg=nord3_term)
    hi("NonText", { guifg="#B48EAD", gui="NONE", ctermfg=5 })

    -- (Pmenu: stock BG was: guibg=nord2_gui, ctermbg=nord1_term)
    hi("Pmenu", { guibg="#4C566A", ctermbg=8 })

    -- (Pmenu: stock BG was: guibg=nord3_gui, ctermbg=nord3_term)
    hi("PmenuThumb", { guibg="#66738e", ctermbg=8 })

    -- QuickFix list's line numbers are unreadable
    hi("qfFileName", { guifg="#5E81AC" })
    hi("qfLineNr", { guifg="#88C0D0" })
    hi("QuickFixLine", { guibg="#8FBCBB", guifg="Black" })

    -- LSP diagnostics: line number backgrounds and foregrounds
    -- ('black' is #667084; bg colours are a blend)
    hi("LspDiagnosticsError", { guifg="#BF616A", guibg="#5C4C58" })
    hi("LspDiagnosticsWarning", { guifg="#EBCB8B", guibg="#4F4B4C" })
    hi("LspDiagnosticsInformation", { guifg="#88C0D0", guibg="#505D6D" })
    hi("LspDiagnosticsHint", { guifg="#5E81AC", guibg="#485165" })

    hi("LspDiagnosticsLineNrError", { guifg="#BF616A", guibg="#5C4C58" })
    hi("LspDiagnosticsLineNrWarning", { guifg="#EBCB8B", guibg="#4F4B4C" })
    hi("LspDiagnosticsLineNrInformation", { guifg="#88C0D0", guibg="#505D6D" })
    hi("LspDiagnosticsLineNrHint", { guifg="#5E81AC", guibg="#485165" })

    -- Folds
    hi("Folded", { guifg="#8FBCBB", gui="italic" })

    -- Suppress overly-aggressive error highlighting under Treesitter
    vim.cmd[[hi clear TSError]]

    -- Theme config
    g.nord_italic = 1
    g.nord_underline = 1
    g.nord_cursor_line_number_background = 1
end


-- NOTE!  Theme config, e.g. lets, _must_ precede the 'colorscheme' cmd to work
vim.api.nvim_exec([[
augroup ColorSchemeOverrides
  autocmd!
  autocmd ColorScheme *    luado my_highlights_all()
  autocmd ColorScheme nord luado my_highlights_nord()
augroup END
]], false)

-- NOW apply the colorscheme.
vim.cmd[[colorscheme nord]]

