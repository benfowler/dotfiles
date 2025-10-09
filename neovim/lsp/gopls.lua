---@type vim.lsp.Config
return {
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
}
