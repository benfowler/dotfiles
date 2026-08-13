-- LemMinX (XML language server) settings.
-- Formatting honours the buffer's detected indent (set by vim-sleuth or editorconfig)
-- and preserves blank lines.

local function push_format_settings(client, bufnr)
    local use_spaces = vim.bo[bufnr].expandtab
    local indent_size = vim.bo[bufnr].shiftwidth
    client.config.settings = vim.tbl_deep_extend('force', client.config.settings or {}, {
        xml = {
            format = {
                enabled = true,
                splitAttributes = 'preserve',
                joinCDATALines = false,
                joinCommentLines = false,
                joinContentLines = false,
                preserveEmptyContent = true,
                preservedNewlines = 2, -- keep up to 2 consecutive blank lines
                insertSpaces = use_spaces,
                tabSize = indent_size,
            },
        },
    })
    client:notify('workspace/didChangeConfiguration', { settings = client.config.settings })
end

return {
    on_attach = function(client, bufnr)
        -- Push immediately so formatting works from the first keypress.
        push_format_settings(client, bufnr)

        -- Re-push when vim-sleuth or editorconfig updates the buffer indent options.
        vim.api.nvim_create_autocmd('OptionSet', {
            pattern = { 'shiftwidth', 'expandtab' },
            callback = function(args)
                if args.buf == bufnr then
                    push_format_settings(client, bufnr)
                end
            end,
        })
    end,
    settings = {
        xml = {
            format = {
                enabled = true,
            },
        },
    },
}
