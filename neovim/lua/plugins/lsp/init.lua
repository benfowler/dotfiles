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
            local null_ls = require "null-ls"

            -- Private custom null-ls sources
            local priv_src_cfn_lint = require "servers.null-ls.sources.cfn-lint"

            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                debug = true,
                log = {
                    enable = true,
                    level = "info",
                    use_console = "async",
                },
                sources = {
                    -- Linters
                    null_ls.builtins.diagnostics.chktex,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.diagnostics.gitlint,
                    null_ls.builtins.diagnostics.golangci_lint,
                    null_ls.builtins.diagnostics.hadolint, -- Dockerfiles
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.diagnostics.jsonlint,
                    null_ls.builtins.diagnostics.markdownlint.with {
                        diagnostics_postprocess = function(diagnostic)
                            diagnostic.severity = vim.diagnostic.severity["HINT"]
                        end,
                    },
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.diagnostics.pylint,
                    null_ls.builtins.diagnostics.shellcheck,
                    null_ls.builtins.diagnostics.yamllint,

                    null_ls.builtins.diagnostics.luacheck.with {
                        extra_args = function()
                            return { "--globals", "vim" }
                        end,
                    },

                    priv_src_cfn_lint.diagnostics.cfn_lint, -- CloudFormation lints

                    -- Code formatters
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.fixjson,
                    null_ls.builtins.formatting.goimports,
                    null_ls.builtins.formatting.reorder_python_imports,
                    null_ls.builtins.formatting.shellharden,
                    null_ls.builtins.formatting.sqlformat,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.terraform_fmt,

                    null_ls.builtins.formatting.prettier.with {
                        filetypes = {
                            "html",
                            "json",
                            "js",
                            "markdown",
                            "typescript",
                            "typescriptreact",
                            "tsx",
                            "yaml",
                        },
                    },

                    -- Additional LSP code action contributions
                    null_ls.builtins.code_actions.eslint,
                    null_ls.builtins.code_actions.shellcheck,
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
                "jsonlint",
                "lua-language-server",
                "luacheck",
                "markdownlint",
                "prettier",
                "shellcheck",
                "shfmt",
                "stylua",
                "yamllint",
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

    -- Show code action signs
    {
        "kosayoda/nvim-lightbulb",
        opts = {
            sign = {
                text = " ",
                hl = "DiagnosticSignWarn",
            },
            autocmd = {
                enabled = true,
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
            "kosayoda/nvim-lightbulb",
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
            -- automatically format on save
            autoformat = false,
            -- LSP Server Settings
            servers = {
                clangd = {
                    init_options = {
                        clangdFileStatus = true,
                    },
                },
                emmet_ls = {
                    filetypes = { "html", "xml", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
                },
                gopls = {
                    cmd = { "gopls", "serve" },
                    root_dir = function(fname)
                        local has_lspconfig, lspconfig = pcall(require, "lspconfig")
                        if has_lspconfig then
                            local lspc_util = lspconfig.util
                            return lspc_util.root_pattern("go.mod", ".git")(fname) or util.path.dirname(fname)
                        end
                    end,
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                                unreachable = false,
                            },
                            codelenses = {
                                generate = true, -- show the `go generate` lens.
                                gc_details = true, --  // Show a code lens toggling the display of gc's choices.
                                test = true,
                                tidy = true,
                            },
                            usePlaceholders = true,
                            completeUnimported = true,
                            staticcheck = true,
                            matcher = "Fuzzy",
                        },
                    },
                    flags = { allow_incremental_sync = true },
                },
                jsonls = {
                    settings = {
                        json = {
                            validate = { enable = true },
                        },
                    },
                },
                lemminx = {
                    filetypes = { "xml", "pom", "xsd", "xsl", "svg" },
                    root_dir = function(fname)
                        local has_lspconfig, lspconfig = pcall(require, "lspconfig")
                        if has_lspconfig then
                            return lspconfig.util.find_git_ancestor(fname) or vim.ui.os_homedir()
                        end
                    end,
                },
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
                        },
                    },
                },
                texlab = {
                    settings = {
                        texlab = {
                            build = {
                                -- See `tectonic --help` for the format
                                executable = "tectonic",
                                args = {
                                    -- Input
                                    "%f",
                                    -- Flags
                                    "--synctex",
                                    "--keep-logs",
                                    "--keep-intermediates",
                                    -- Options
                                    -- OPTIONAL: If you want a custom out directory,
                                    -- uncomment the following line.
                                    --"--outdir out",
                                },
                                forwardSearchAfter = true,
                                onSave = true,
                            },
                            forwardSearch = {
                                executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                                args = { "-g", "%l", "%p", "%f" },
                                onSave = true,
                            },
                            chktex = {
                                onOpenAndSave = true, -- extra lints
                                onEdit = true, -- give me lints, good and hard
                            },
                            -- OPTIONAL: The server needs to be configured
                            -- to read the logs from the out directory as well.
                            -- auxDirectory = "out",
                        },
                    },
                },
            },

            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            setup = {
                -- typescript = function(server, opts)
                -- end,
                -- Specify * to use this function as a fallback for any server
                ["*"] = function(_, _) end, -- (server, opts)
            },
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            -- setup autoformat
            require("plugins.lsp.format").autoformat = opts.autoformat

            -- setup formatting and keymaps
            util.on_attach(function(client, buffer)
                require("plugins.lsp.format").on_attach(client, buffer)
                require("plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            -- Diagnostics
            local lsp_icons = require("util").diagnostic_icons.filled
            local function lspSymbol(key, icon)
                vim.fn.sign_define("DiagnosticSign" .. key, {
                    text = icon,
                    texthl = "DiagnosticSign" .. key,
                    linehl = nil,
                    numhl = "DiagnosticLineNr" .. key,
                })
            end

            lspSymbol("Error", lsp_icons.error)
            lspSymbol("Warn", lsp_icons.warn)
            lspSymbol("Info", lsp_icons.info)
            lspSymbol("Hint", lsp_icons.hint)

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            -- Popups get frames with rounded corners
            -- stylua: ignore start
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            -- stylua: ignore end

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
