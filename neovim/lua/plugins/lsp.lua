return {

    -- nvim-lspconfig (for canned configs only; requires v0.11+)
    {
        'neovim/nvim-lspconfig',
        lazy = false,
    },

    -- Show LSP server activity as an overlay
    {
        'j-hui/fidget.nvim',
        lazy = false,
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },

    -- Core Copilot integration
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        ---@type CopilotConfig
        opts = {
            -- Disable native ghost text UI modules to prevent overlapping renders
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                ['*'] = true,
                -- Disable Copilot in certain filetypes
                ['TelescopePrompt'] = false,
                ['NvimTree'] = false,
                ['markdown'] = false,
                ['text'] = false,
            },
        },
    },

    -- Use blink.cmp for fuzzy autocomplete in LSP
    {
        'saghen/blink.cmp',
        version = 'v1.10.2', -- pin this to a release to keep running; use pre-built fuzzy finder binary
        dependencies = { 'fang2hou/blink-copilot' },
        ---@type blink.cmp.Config
        opts = {

            -- Menu formatting and colorisation
            appearance = {
                nerd_font_variant = 'mono',
            },

            -- General completion options
            completion = {
                accept = { auto_brackets = { enabled = true } },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 250,
                    treesitter_highlighting = true,
                    window = { border = 'rounded' },
                },

                ghost_text = {
                    enabled = true,
                    show_with_menu = false, -- only show when menu is closed
                },

                menu = {
                    auto_show = false,
                    draw = {
                        columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
                    },
                    max_height = 15,
                    winblend = 5,
                },
            },

            -- Register Copilot as a backend completion provider
            sources = {
                default = function()
                    local ok = pcall(require, 'copilot')
                    if ok then
                        return { 'lsp', 'path', 'snippets', 'buffer', 'copilot' }
                    else
                        return { 'lsp', 'path', 'snippets', 'buffer' }
                    end
                end,
                providers = {
                    copilot = {
                        name = 'copilot',
                        module = 'blink-copilot',
                        score_offset = 100, -- Forces Copilot to the top for instant ghost text
                        async = true,
                        opts = {
                            max_completions = 3,
                        },
                    },
                },
            },

            -- Enable snippet support (requires luasnip or mini.snippets)
            snippets = {
                preset = 'luasnip',
            },
        },
    },

    -- CodeLenses
    {
        'oribarilan/lensline.nvim',
        event = 'LspAttach',
        config = function()
            require('lensline').setup({
                profiles = {
                    {
                        name = 'minimal',
                        style = {
                            highlight = 'Conceal',
                            placement = 'inline',
                            prefix = '',
                            render = 'focused', -- optionally render lenses only for focused function
                        },
                    },
                },
            })
        end,
    },

    -- Show code action signs
    {
        'kosayoda/nvim-lightbulb',
        lazy = false,
        ---@type nvim-lightbulb.Config
        opts = {
            code_lenses = true,
            sign = {
                text = ' ',
                lens_text = ' ',
                hl = 'DiagnosticSignWarn',
            },
            autocmd = {
                enabled = true,
            },
        },
    },

    -- Lua plugin dev: faster lua_ls startup: provides plugin type stubs on demand instead of
    -- indexing the entire lazy plugin directory up front
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        ---@type lazydev.Config
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                { path = 'lazy.nvim', words = { 'lazy', 'LazySpec', 'LazyConfig', 'LazyPlugin', 'LazyKeys' } },
            },
        },
    },

    -- Linting (diagnostics from external CLI tools, e.g. eslint_d).
    --
    -- Prereq: `brew install eslint_d`
    {
        'mfussenegger/nvim-lint',
        event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
        config = function()
            local lint = require('lint')

            lint.linters_by_ft = {
                javascript = { 'eslint_d' },
                javascriptreact = { 'eslint_d' },
                typescript = { 'eslint_d' },
                typescriptreact = { 'eslint_d' },
            }

            -- Lint on save (and after leaving insert mode, so diagnostics stay fresh
            -- without needing a manual trigger). eslint_d manages its own background
            -- daemon, so this stays fast even on repeated invocations.
            vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
                group = vim.api.nvim_create_augroup('my_nvim_lint', { clear = true }),
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    -- Formatting via external CLI tools (e.g. Prettier), with format-on-save.
    --
    -- Prereq: `brew install prettierd`
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                javascript = { 'prettierd' },
                javascriptreact = { 'prettierd' },
                typescript = { 'prettierd' },
                typescriptreact = { 'prettierd' },
                json = { 'prettierd' },
                jsonc = { 'prettierd' },
                css = { 'prettierd' },
            },
            format_on_save = {
                lsp_format = 'never',
                timeout_ms = 1000,
            },
        },
    },
}
