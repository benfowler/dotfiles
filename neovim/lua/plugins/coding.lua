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
        config = function()
            local luasnip = require "luasnip"
            local types = require "luasnip.util.types"
            luasnip.config.setup {
                history = false,
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
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "saadparwaiz1/cmp_luasnip" },
            { "micangl/cmp-vimtex" },
        },
        config = function()
            local cmp = require "cmp"
            local luasnip = require "luasnip"
            local icons = require("lspkind").symbol_map

            -- Insert parenthesis after select function or method name
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
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
                    ["<C-N>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
                    ["<C-P>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
                    ["<C-F>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),  -- reverse doc-scrolling direction for comfort
                    ["<C-B>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
                    ["<Esc>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
                    ["<C-E>"] = cmp.mapping(function()
                        if luasnip.choice_active() then
                            luasnip.change_choice(1)
                        end
                    end, { "i", "s" }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                            else
                                cmp.confirm { select = true }
                            end
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
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
                    ["<Enter>"] = cmp.mapping(function(fallback)
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
                },
                enabled = function()

                    -- Enable/disable via buffer variable
                    --if not vim.b.cmp then return true end    -- implicitly enabled
                    --if vim.b.cmp == 0 then return false end  -- explicitly disabled

                    -- Disable completion in Treesitter comments
                    local context = require "cmp.config.context"
                    if vim.api.nvim_get_mode().mode == "c" then   -- keep command mode completion enabled when cursor is in a comment
                        return true
                    else
                        return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
                    end
                end,
                preselect = cmp.PreselectMode.None,
                sources = {
                    { name = "nvim_lsp_signature_help" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "path" },
                    { name = "luasnip" },
                    { name = "vimtex" },
                },
                experimental = {
                    ghost_text = {
                        hl_group = "NonText",
                    },
                },
            }

            -- filetype-specific setup is done here
            cmp.setup.filetype({ 'markdown' }, {
                completion = {
                    autocomplete = false,
                }
            })
        end,
    },

    {
        -- XML autocomplete
        "windwp/nvim-ts-autotag",
        lazy = false,
        config = function ()
            require('nvim-ts-autotag').setup()
        end
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
        config = function()
            require("colorizer").setup({
                '*',
                'css',
                'javascript',
            }, {
                RGB = true,
                RRGGBB = true,
                names = false
            })
        end,
    }
}
