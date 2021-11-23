local M = {}

local g = vim.g
local opt = vim.opt

local ps = require("pluginsEnabled").plugin_status

M.autopairs = function()
    local present1, autopairs = pcall(require, "nvim-autopairs")
    local present2, autopairs_completion = pcall(require, "nvim-autopairs.completion.cmp")

    if not (present1 or present2) then
        return
    end

    autopairs.setup()
    autopairs_completion.setup {
        map_complete = true, -- insert () func completion
        map_cr = true,
    }
end

M.numb = function()
    require("numb").setup()
end

M.colorizer = function()
    if ps.nvim_colorizer == true then
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
end

M.statusline = function()
    if ps.statusline == true then
        require("statusline").setup()
    end
end

M.comment = function()
    if ps.nvim_comment == true then
        require("nvim_comment").setup()
    end
end

M.luasnip = function()
    local present, luasnip = pcall(require, "luasnip")
    if not present then
        return
    end
    luasnip.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
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
            doc_lines = 5,
            floating_window = true,
            fix_pos = true,
            hint_enable = true,
            hint_prefix = " ",
            hint_scheme = "String",
            hi_parameter = "Search",
            max_height = 15,
            max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
            transparency = 10,
            handler_opts = {
                --border = "single", -- double, single, shadow, none
            },
            zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
            padding = " ", -- character to pad on left and right of signature can be ' ', or '|'  etc
            timer_interval = 100,
            toggle_key = "<F1>",
        }
    end
end

return M
