local g = vim.g
local opt = vim.opt
local cmd = vim.cmd


-- Utility method to make setting highlights not suck
function hi(group, opts)
	local c = "highlight " .. group
	for k, v in pairs(opts) do
		c = c .. " " .. k .. "=" .. v
	end
	vim.cmd(c)
end

function hi_link(old, new, is_forced)
    local c = "highlight" .. (is_forced and "!" or "") .. " link " .. old .. " " .. new
    vim.cmd(c)
end

function hi_clear(name) 
    local c = "highlight clear " .. name
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
local nord0 = "#2E3440"
local nord1 = "#3B4252"
local nord2 = "#434C5E"
local nord3 = "#4C566A"
local nord3_bright = "#616E88"
local nord4 = "#D8DEE9"
local nord5 = "#E5E9F0"
local nord6 = "#ECEFF4"
local nord7 = "#8FBCBB"
local nord8 = "#88C0D0"
local nord9 = "#81A1C1"
local nord10 = "#5E81AC"
local nord11 = "#BF616A"
local nord12 = "#D08770"
local nord13 = "#EBCB8B"
local nord14 = "#A3BE8C"
local nord15 = "#B48EAD"

function my_highlights_nord()

    -- (poor readability of some highlight groups)
    -- (Stock fg was: guifg=nord3_gui, ctermfg=nord3_term)
    hi("SpecialKey", { guifg=nord3_bright, ctermfg=8 })

    -- (Stock fg was: guifg=nord2_gui, gui=bold, ctermfg=nord3_term)
    hi("NonText", { guifg=nord15, gui="NONE", ctermfg=5 })

    -- (Pmenu: stock BG was: guibg=nord2_gui, ctermbg=nord1_term)
    hi("Pmenu", { guibg=nord3, ctermbg=8 })

    -- (Pmenu: stock BG was: guibg=nord3_gui, ctermbg=nord3_term)
    hi("PmenuThumb", { guibg="#66738e", ctermbg=8 })

    -- QuickFix list's line numbers are unreadable
    hi("qfFileName", { guifg=nord10 })
    hi("qfLineNr", { guifg=nord8 })
    hi("QuickFixLine", { guibg=nord7, guifg="Black" })

    -- Active statusbar: override 'StatusLine' highlight with Nord-ish colours
    hi("StatusLine", { guifg=nord4, guibg=nord2 })

    -- Inactive statusbars: make a thin rule
    hi_clear("StatusLineNC")
    hi("StatusLineNC", { gui="underline", guifg=nord2 })

    -- Line numbers: tweaks to show current line
    hi_clear("CursorLine")
    hi_clear("CursorLineNr")
    hi_link("CursorLineNr", "Bold", true)

    -- LSP diagnostics: line number backgrounds and foregrounds
    -- ('black' is #667084; bg colours are a blend)
    hi("LspDiagnosticsError", { guifg=nord11, guibg="#5C4C58" })
    hi("LspDiagnosticsWarning", { guifg=nord13, guibg="#4F4B4C" })
    hi("LspDiagnosticsInformation", { guifg=nord8, guibg="#505D6D" })
    hi("LspDiagnosticsHint", { guifg=nord10, guibg="#485165" })

    hi("LspDiagnosticsLineNrError", { guifg=nord11, guibg="#5C4C58" })
    hi("LspDiagnosticsLineNrWarning", { guifg=nord13, guibg="#4F4B4C" })
    hi("LspDiagnosticsLineNrInformation", { guifg=nord8, guibg="#505D6D" })
    hi("LspDiagnosticsLineNrHint", { guifg=nord10, guibg="#485165" })

    -- Folds
    hi("Folded", { guifg=nord7, gui="italic" })

    -- Git gutter signs
    hi("GitSignsAdd", { guifg=nord9 })
    hi("GitSignsChange", { guifg="#565c68" })
    hi("GitSignsDelete", { gui="bold", guifg="#ba5c65" })
    hi("GitSignsChangeDelete", { gui="bold", guifg="#ba5c65", guibg=nord1 })

    -- Telescope 
    hi_link("TelescopeSelection", "Visual", true)
    hi_link("TelescopeSelectionCaret", "Annotation", true)
    hi_link("TelescopeMultiSelection", "DiffAdd", true)
    hi_link("TelescopeMatching", "String", true)
    hi_link("TelescopePromptPrefix", "ALEErrorSign", true)
    hi_link("TelescopeBorder", "Comment", true)

    -- Suppress overly-aggressive error highlighting under Treesitter
    hi_clear("TSError")
end


-- NOTE!  Theme config, e.g. lets, _must_ precede the 'colorscheme' cmd to work
vim.api.nvim_exec([[
augroup ColorSchemeOverrides
  autocmd!
  autocmd ColorScheme *    luado my_highlights_all()
  autocmd ColorScheme nord luado my_highlights_nord()
augroup END
]], false)


g.nord_contrast = false
g.nord_enable_sidebar_background = false
g.nord_disable_background = true
g.nord_borders = true
g.nord_cursorline_transparent = true
g.nord_italic = false


-- NOW apply the colorscheme.
vim.cmd [[ colo nord ]]

