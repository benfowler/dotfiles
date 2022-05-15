local M = {}

M.configure = function(on_attach, capabilities, debounce_msec)
    return {
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
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
        flags = { debounce_text_changes = debounce_msec },
    }
end

return M
