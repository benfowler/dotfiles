local maps = require "config.keymaps"
local util = require "util"

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
