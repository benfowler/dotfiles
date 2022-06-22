local null_ls = require "null-ls"

-- Private custom null-ls sources
local priv_src_cfn_lint = require "servers.null-ls.sources.cfn-lint"

local M = {}

M.configure = function(on_attach, capabilities, debounce_msec)
    return {
        debounce = debounce_msec,
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
                filetypes = { "html", "json", "js", "markdown", "typescript", "typescriptreact", "tsx", "yaml" },
            },

            -- Additional LSP code action contributions
            null_ls.builtins.code_actions.eslint,
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.code_actions.shellcheck,
        },

        on_attach = on_attach,
        capabilities = capabilities,
    }
end

return M
