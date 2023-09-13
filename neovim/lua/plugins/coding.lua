local maps = require "config.keymaps"

return {

    {
        -- Snippets
        "L3MON4D3/LuaSnip",
        build = (not jit.os:find "Windows")
                and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or nil,
        dependencies = {
            "rafamadriz/friendly-snippets", -- LSP-format snippets
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                require("luasnip.loaders.from_vscode").lazy_load { paths = { "./vscode-snippets" } }
            end,
        },
        opts = function()
            local luasnip = require "luasnip"
            local types = require "luasnip.util.types"
            luasnip.config.set_config {
                history = true, -- 'true' is annoying
                delete_check_events = "InsertLeave,TextChanged",
                updateevents = "InsertLeave,TextChanged,TextChangedI",
                store_selection_keys = "<Tab>",
                ext_opts = {
                    [types.choiceNode] = {
                        active = {
                            virt_text = { { "●", "LuasnipChoiceNodeVirtualText" } },
                        },
                    },
                    [types.insertNode] = {
                        active = {
                            virt_text = { { "●", "LuasnipInsertNodeVirtualText" } },
                        },
                    },
                },
            }

            -- Advanced LuaSnip-native snippets (mine)
            require "luasnip.snippets.markdown"
        end,
    },

    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "onsails/lspkind.nvim" },

            -- Completion sources
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "saadparwaiz1/cmp_luasnip" },
            { "kdheepak/cmp-latex-symbols" },
        },
        config = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"
            local icons = require("lspkind").symbol_map

            -- Supertab-like tab behaviour
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            cmp.setup {
                confirmation = {
                    get_commit_characters = function()
                        return {}
                    end,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    autocomplete = false,
                    completeopt = "menu,menuone,noinsert",
                    keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
                    keyword_length = 1,
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(_, vim_item)
                        vim_item.menu = " " .. vim_item.kind
                        vim_item.kind = icons[vim_item.kind]
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 45) -- truncate items
                        return vim_item
                    end,
                },
                window = {
                    documentation = {
                        border = { "", "", "", " ", "", "", "", " " },
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                    },
                },
                view = {
                    entries = { name = "custom" },
                },
                mapping = {
                    ["<C-Y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    -- NOTE: to be truly IntelliJ-like, C-J must trigger the docs_view
                    -- ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
                    ["<C-N>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
                    ["<C-P>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
                    ["<C-D>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
                    ["<C-F>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
                    ["<C-E>"] = cmp.mapping(function(fallback)
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    -- NOTE: to be truly IntelliJ-like, Esc should just dismiss the docs_view if visible... and only then, dismiss the autocompletion popup
                    ["<Esc>"] = cmp.mapping {
                        i = cmp.mapping.abort(),
                    },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        -- IntelliJ-like mapping (see nvim-cmp wiki)
                        -- Confirm with tab, and if no entry is selected, confirm first item
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                            else
                                cmp.confirm { select = true }
                            end
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            -- Supertab-like behaviour
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    -- NOTE: to be truly IntelliJ-like, <Enter> should do the same as <Tab>
                    ["<Enter>"] = cmp.mapping(function(fallback)
                        -- Try to emulate IntelliJ's completion popup behaviour
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item()
                            else
                                cmp.confirm()
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                enabled = function()
                    -- Disable completion in Treesitter comments
                    local context = require "cmp.config.context"
                    if vim.api.nvim_get_mode().mode == "c" then -- keep command mode completion enabled when cursor is in a comment
                        return true
                    else
                        return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
                    end
                end,
                preselect = cmp.PreselectMode.None,
                sources = {
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "luasnip" },
                    { name = "latex_symbols" },
                    { name = "nvim_lsp_signature_help" },
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
            }
        end,
    },

    {
        -- Easy code commenting
        "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        config = function()
            require("nvim_comment").setup()
        end,
        keys = {
            { maps.comment_nvim.comment_toggle, ":CommentToggle<CR>", mode = { "n", "v" }, desc = "(Un)comment" },
        },
    },

    {
        -- Pair completion
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            -- Don't add pairs if the next char is alphanumeric
            ignored_next_char = "[%w%.%$]", -- will ignore alphanumeric, `$` and `.` symbol

            -- Enable the very nice 'fast wrap' feature.  Activate with <M>-e.
            fast_wrap = {},
            highlight = "Search",
            highlight_grey = "Comment",

            -- Don't add pairs if it already has a close pair in the same line
            enable_check_bracket_line = true,
        },
    },

    {
        -- Make CSS colours stand out in files
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            "*",
            css = { css = true },
            html = { css = true },
        },
    },

    {
        -- jsonnet support
        "google/vim-jsonnet",
        ft = "jsonnet",
    }
}
