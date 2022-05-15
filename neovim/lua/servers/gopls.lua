local has_lspconfig, lspconfig = pcall(require, "lspconfig")

local M = {}

M.configure = function(on_attach, capabilities, debounce_msec)
    return {
        cmd = { "gopls", "serve" },
        root_dir = function(fname)
            if has_lspconfig then
                local util = lspconfig.util
                return util.root_pattern("go.mod", ".git")(fname) or util.path.dirname(fname)
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
        flags = { allow_incremental_sync = true, debounce_text_changes = debounce_msec},
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

return M
