---@type vim.lsp.Config
return {
    settings = {
        gopls = {
            analyses = {
                unreachable = true,
                unusedparams = true,
            },
            codelenses = {
                generate = true, -- show the `go generate` lens.
                gc_details = true, --  // Show a code lens toggling the display of gc's choices.
                test = true,
                tidy = true,
            },
            completeUnimported = true,
            gofumpt = true,
            matcher = 'Fuzzy',
            semanticTokens = true,
            staticcheck = true,
            usePlaceholders = true,
        },
    },
}
