-- vtsls (VSCode's TypeScript language service, wrapped as an LSP).
--
-- Prereq: `brew install vtsls`

---@type vim.lsp.Config
return {
    settings = {
        typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            inlayHints = {
                parameterNames = { enabled = 'all' },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
        },
        javascript = {
            updateImportsOnFileMove = { enabled = 'always' },
            inlayHints = {
                parameterNames = { enabled = 'all' },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
        },
    },
}
