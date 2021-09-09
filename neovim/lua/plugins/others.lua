local M = {}

local g = vim.g
local w = vim.w
local opt = vim.opt

M.colorizer = function()
    local present, colorizer = pcall(require, "colorizer")
    if present then
        colorizer.setup()
        vim.cmd "ColorizerReloadAllBuffers"
    end
end

M.comment = function()
    local present, nvim_comment = pcall(require, "nvim_comment")
    if present then
        nvim_comment.setup()
    end
end

M.markdown = function()
    -- required for sane bullet-list editing
    opt.comments = "b:>"
    opt.formatoptions = "jtcqlnr"

    g.vim_markdown_new_list_item_indent = 2
    g.vim_markdown_auto_insert_bullets = 0
end

M.bullets = function()
    g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
end

M.lspkind = function()
    local present, lspkind = pcall(require, "lspkind")
    if present then
        lspkind.init()
    end
end

M.lightbulb = function()
    -- stylua: ignore
    vim.cmd [[
        augroup customisation_plugin_lightbulb
            autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            au ColorScheme * highlight LightBulbFloatWin ctermfg= ctermbg= guifg= guibg=
            au ColorScheme * highlight LightBulbVirtualText ctermfg= ctermbg= guifg= guibg=
            sign define LightBulbSign text=ﯧ texthl=Annotation linehl= numhl=
        augroup END
    ]]
end

M.blankline = function()
    g.indentLine_enabled = 1
    g.indent_blankline_char = "▏"

    g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard", "packer" }
    g.indent_blankline_buftype_exclude = { "terminal" }

    g.indent_blankline_show_trailing_blankline_indent = false
    g.indent_blankline_show_first_indent_level = false
end

M.signature = function()
    local present, lspsignature = pcall(require, "lsp_signature")
    if present then
        lspsignature.setup {
            bind = true,
            doc_lines = 2,
            floating_window = true,
            fix_pos = true,
            hint_enable = true,
            hint_prefix = " ",
            hint_scheme = "String",
            use_lspsaga = false,
            hi_parameter = "Search",
            max_height = 22,
            max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
            handler_opts = {
                border = "single", -- double, single, shadow, none
            },
            zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
            padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
        }
    end
end

return M
