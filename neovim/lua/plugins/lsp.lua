local maps = require "config.keymaps"

-- CREDIT: borrowed heavily - and pruned - from https://github.com/folke/LazyVim/

return {

    -- Diagnostic servers (linters and formatters)
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "mason.nvim" },
        opts = function()
            local nls = require "null-ls"
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    nls.builtins.formatting.stylua,
                    nls.builtins.formatting.shfmt,
                },
            }
        end,
    },

    -- Command-line tools and diagnostic servers
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { maps.packages.mason, "<cmd>Mason<cr>", desc = "Mason" } },
        opts = {
            ensure_installed = {
                "lua-language-server",
                "stylua",
                "shfmt",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr = require "mason-registry"
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },

    -- Snippets
    {
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

    -- Autocompletion
    {
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

    -- Show LSP server activity as an overlay
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
            text = {
                spinner = "dots",
                done = " ",
                completed = "Done",
            },
            timer = {
                fidget_decay = 3600,
                task_decay = 1800,
            },
            window = {
                blend = 5,
            },
        },
    },

    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "j-hui/fidget.nvim",
        },
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "󰓛",
                },
                signs = true,
                severity_sort = true,
                underline = true,
                update_in_insert = false,
            },
            -- add any global capabilities here
            capabilities = {},
            -- Automatically format on save
            autoformat = true,
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            servers = {
                jsonls = {},
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                            completion = { enable = true, callSnippet = "Both" },
                            diagnostics = {
                                enable = true,
                                globals = { "vim", "describe" },
                                disable = { "lowercase-global" },
                            },
                            workspace = {
                                library = {
                                    [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                                    [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                                },
                                maxPreload = 100000,
                                preloadFileSize = 10000,
                            },
                            telemetry = {
                                enable = false,
                            },
                        }
                    }
                }
            },

            -- TODO: stitch in my custom LSP server configs here

            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)

            -- TODO: fix autoformat

            -- setup autoformat
            -- require("lazyvim.plugins.lsp.format").autoformat = opts.autoformat
            -- setup formatting and keymaps

            -- TODO: fix LSP keybindings

            -- util.on_attach(function(client, buffer)
            --     require("lazyvim.plugins.lsp.format").on_attach(client, buffer)
            --     require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
            -- end)

            -- TODO: configure diagnostic icons here

            -- diagnostics
            -- for name, icon in pairs(require("lazyvim.config").icons.diagnostics) do
            --     name = "DiagnosticSign" .. name
            --     vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
            -- end
            --
            -- if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
            --     opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
            --         or function(diagnostic)
            --             local icons = require("lazyvim.config").icons.diagnostics
            --             for d, icon in pairs(icons) do
            --                 if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            --                     return icon
            --                 end
            --             end
            --         end
            -- end
            --
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            local servers = opts.servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(),
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available thourgh mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mslp_servers = {}
            if have_mason then
                all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {} ---@type string[]
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup { ensure_installed = ensure_installed }
                mlsp.setup_handlers { setup }
            end

        end,
    },

}
