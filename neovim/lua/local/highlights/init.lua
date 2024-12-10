
-- Taken from Neovim source code
local nvimStockColours = {
    NvimDarkBlue     = "#004c73",
    NvimDarkCyan     = "#007373",
    NvimDarkGreen    = "#005523",
    NvimDarkGrey1    = "#07080d",
    NvimDarkGrey2    = "#14161b",
    NvimDarkGrey3    = "#2c2e33",
    NvimDarkGrey4    = "#4f5258",
    NvimDarkMagenta  = "#470045",
    NvimDarkRed      = "#590008",
    NvimDarkYellow   = "#6b5300",
    NvimLightBlue    = "#a6dbff",
    NvimLightCyan    = "#8cf8f7",
    NvimLightGreen   = "#b3f6c0",
    NvimLightGrey1   = "#eef1f8",
    NvimLightGrey2   = "#e0e2ea",
    NvimLightGrey3   = "#c4c6cd",
    NvimLightGrey4   = "#9b9ea4",
    NvimLightMagenta = "#ffcaff",
    NvimLightRed     = "#ffc0b9",
    NvimLightYellow  = "#fce094",
}

-- If using the default Neovim color scheme, force-reset all highlight groups
if vim.g.colors_name == nil or vim.g.colors_name == "default" then

    -- HACK: default colour scheme changes assigned colours depend on 'background' option.
    --
    -- Tweak highlight groups' properties while preserving stock colours by monkey-patching
    -- the default colourscheme when the background colour changes

    if string.find(vim.env.TERM, "xterm-kitty", 1, true) ~= nil then

        -- Reset highlight groups to default
        vim.cmd [[ color default ]]

        -- Tweak stock colors for highlight groups.
        -- (This doesn't work in Lua)
        vim.cmd [[
            highlight DiagnosticUnderlineError gui=undercurl
            highlight DiagnosticUnderlineWarn gui=undercurl
            highlight DiagnosticUnderlineInfo gui=undercurl
            highlight DiagnosticUnderlineHint gui=undercurl
        ]]
    end
end

-- Customisations of stock highlights
vim.api.nvim_set_hl(0, "ColorColumn", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "FoldColumn", { link = "NonText" })

vim.api.nvim_set_hl(0, "mkdLinkDef", { fg="#4fa6ed", underline=true })
vim.api.nvim_set_hl(0, "mkdLink", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "mkdInlineURL", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.quote.markdown", { link = "mkdBlockQuote" })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "mkdCode" })
vim.api.nvim_set_hl(0, "Identifier", { link="NonText" })

vim.api.nvim_set_hl(0, "LspCodeLens", { link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "NonText" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { link = "DiagnosticHint" })

-- Inactive statusbars: make a thin rule; align vertsplit to match.
vim.cmd [[ highlight StatusLineNC guifg=NONE guisp=NvimDarkGrey4 guibg=NONE gui=underline ]]
vim.api.nvim_set_hl(0, "VertSplit", { link = "NonText" })
vim.api.nvim_set_hl(0, "WinSeparator", { link = "NonText" })

-- Plugin: Luasnip
vim.api.nvim_set_hl(0, "LuasnipChoiceNodeVirtualText", { link = "@diff.minus" })
vim.api.nvim_set_hl(0, "LuasnipInsertNodeVirtualText", { link = "@diff.delta" })

-- Plugin: NVimtree
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { link = "NvimTreeNormal" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { link = "NvimTreeFolderIcon" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { link = "NvimTreeNormal" })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderIcon", { link = "NvimTreeFolderIcon" })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { link = "NvimTreeFolderIcon" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "NonText" })

-- My custom winbar
vim.cmd [[
    highlight link WinBar Comment
    highlight Winbar gui=italic guibg=NONE
]]

vim.api.nvim_set_hl(0, "ErrorWinbarDiagIndic", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "WarnWinbarDiagIndic", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "InfoWinbarDiagIndic", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "HintWinbarDiagIndic", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "OkWinbarDiagIndic", { link = "DiagnosticOk" })

-- My custom statusbar  (NOTE: linked highlights chosen to look nicer, not match logicically)
vim.api.nvim_set_hl(0, "StatusLineModeCommand", { link="MiniStatusLineModeInsert" })
vim.api.nvim_set_hl(0, "StatusLineModeEx", { link="MiniStatusLineModeCommand" })
vim.api.nvim_set_hl(0, "StatusLineModeInsert", { link="MiniStatusLineModeOther" })
vim.api.nvim_set_hl(0, "StatusLineModeReplace", { link="MiniStatusLineModeReplace" })
vim.api.nvim_set_hl(0, "StatusLineModeTerminal", { link="MiniStatusLineModeNormal" })
vim.api.nvim_set_hl(0, "StatusLineModeVisual", { link="MiniStatusLineModeCommand" })
vim.api.nvim_set_hl(0, "StatusLineModeSelect", { link="MiniStatusLineModeVisual" })

