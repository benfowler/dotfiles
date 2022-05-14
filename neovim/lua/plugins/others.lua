local M = {}

local g = vim.g
local opt = vim.opt

M.autopairs = function()
    local has_autopairs, autopairs = pcall(require, "nvim-autopairs")

    local has_autopairs_cmp, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    local cmp = require('cmp')

    if not (has_autopairs or has_autopairs_cmp) then
        return
    end

    -- nvim-cmp integration
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

    autopairs.setup({
      -- Don't add pairs if the next char is alphanumeric
      ignored_next_char = "[%w%.%$]",   -- will ignore alphanumeric, `$` and `.` symbol

      -- Enable the very nice 'fast wrap' feature.  Activate with <M>-e.
      fast_wrap = {},
      highlight = 'Search',
      highlight_grey = 'Comment',

      -- Don't add pairs if it already has a close pair in the same line
      enable_check_bracket_line = false,
    })
end

M.numb = function()
    require("numb").setup()
end

M.colorizer = function()
    require("colorizer").setup({
        "*";
        css = { css = true; };
        html = { css = true; };
    }, {
        RRGGBB = true;
        RGB = false;
        names = false;
    })

    vim.cmd "ColorizerReloadAllBuffers"
end

M.statusline = function()
    require("statusline").setup()
end

M.comment = function()
    require("nvim_comment").setup()
end

M.dressing = function()
    require("dressing").setup({
        input = {
            winblend = 0,
            winhighlight = "FloatBorder:DressingFloatBorder",
        },
    })
end

M.notify = function ()
    local notify = require("notify")
    notify.setup({
        background_colour = "#2E3440",
    })
    vim.notify = notify
end

M.fidget = function()
    require "fidget".setup({
        text = {
            spinner = "dots",
            done = " ",
        },
        timer = {
            fidget_decay = 3600,
            task_decay = 1800,
        },
        window = {
            blend = 5,
        }
    })

    local u = require("utils")
    u.Hi("FidgetTitle", { gui = "bold", guifg = "#b48ead", guibg = "#2e3440" })
    u.Hi("FidgetTask", { guifg = "#616e88", guibg = "#2e3440" })
end

M.luasnip = function()
    local present, luasnip = pcall(require, "luasnip")
    if not present then
        return
    end

    local types = require("luasnip.util.types")
    luasnip.config.set_config {
        history = true,   -- 'true' is annoying
        delete_check_events = "InsertLeave,TextChanged",
        updateevents = "InsertLeave,TextChanged,TextChangedI",
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = {{"●", "LuasnipChoiceNodeVirtualText"}}
                }
            },
            [types.insertNode] = {
                active = {
                    virt_text = {{"●", "LuasnipInsertNodeVirtualText"}}
                }
            }
        },
    }

    require("luasnip/loaders/from_vscode").load()
    require("luasnip/loaders/from_vscode").load { paths = { "./vscode-snippets" } }
end

M.markdown = function()
    -- required for sane bullet-list editing
    opt.comments = "b:>"
    opt.formatoptions = "jtcqlnr"
    g.vim_markdown_new_list_item_indent = 2
    g.vim_markdown_auto_insert_bullets = 0
    g.vim_markdown_math = 1
end

--Plug 'lervag/vimtex'
M.vimtex = function()
    g.tex_flavor = "latex"
    g.vimtex_view_method = "skim"
    g.vimtex_quickfix_mode = 0
    opt.conceallevel = 1
    g.tex_conceal = "abdmg"
end

M.bullets = function()
    g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
end

M.lightbulb = function()
    -- stylua: ignore
    vim.cmd [[
        augroup customisation_plugin_lightbulb
            autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            au ColorScheme * highlight LightBulbFloatWin ctermfg= ctermbg= guifg= guibg=
            au ColorScheme * highlight LightBulbVirtualText ctermfg= ctermbg= guifg= guibg=
            sign define LightBulbSign text=ﯧ texthl=DiagnosticWarn linehl= numhl=
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
            fix_pos = true,
            hint_prefix = " ",
            hint_scheme = "LspDiagnosticsDefaultWarning",
            hi_parameter = "Search",
                handler_opts = {
                    border = "rounded", -- double, single, shadow, none
                },
            padding = " ", -- character to pad on left and right of signature can be ' ', or '|'  etc
            toggle_key = "<F1>",
        }
    end
end

return M
