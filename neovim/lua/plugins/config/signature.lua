local present, lspsignature = pcall(require, "lsp_signature")
if present then
    lspsignature.setup {
        fix_pos = true,
        hint_prefix = " ",
        hint_scheme = "LspDiagnosticsDefaultWarning",
        hi_parameter = "Search",
        handler_opts = {
            border = "rounded",
        },
        padding = " ",
        toggle_key = "<F1>",
    }
end
