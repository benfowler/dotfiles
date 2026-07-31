
local maps = require "config.keymaps"
local util = require "util"

local lsp_icons = util.diagnostic_icons.outline


-- Enabled language servers
vim.lsp.enable('basedpyright')
vim.lsp.enable('bashls')
vim.lsp.enable('clangd')
vim.lsp.enable('cssls')
vim.lsp.enable('emmet_language_server')
vim.lsp.enable('gopls')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')
vim.lsp.enable('lemminx')
vim.lsp.enable('lua_ls')
vim.lsp.enable('texlab')
vim.lsp.enable('yamlls')


-- Global defaults
vim.lsp.config('*', {
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            },
            semanticTokens = {
                multilineTokenSupport = true,
            },
        }
    },
    root_markers = { '.git' },
})


-- Remove or override BUFFER-LOCAL defaults
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)

    -- Customise diagnostics
    local dg_error = vim.diagnostic.severity.ERROR
    local dg_warn = vim.diagnostic.severity.WARN
    local dg_info = vim.diagnostic.severity.INFO
    local dg_hint = vim.diagnostic.severity.HINT

    vim.diagnostic.config({
        float = {
            border = "rounded",
        },
        signs = {
            text = {
                [dg_error] = lsp_icons.error, [dg_warn] = lsp_icons.warn, [dg_info] = lsp_icons.info, [dg_hint] = lsp_icons.hint,
            },
            texthl = {
                [dg_error] = "DiagnosticSignError", [dg_warn] = "DiagnosticSignWarn", [dg_info] = "DiagnosticSignInfo", [dg_hint] = "DiagnosticSignHint",
            },
            numhl = {
                [dg_error] = "DiagnosticLineNrError", [dg_warn] = "DiagnosticLineNrWarn", [dg_info] = "DiagnosticLineNrInfo", [dg_hint] = "DiagnosticLineNrHint",
            },
            linehl = {
                [dg_error] = nil , [dg_warn] = nil, [dg_info] = nil, [dg_hint] = nil,
            },

        },
        severity_sort = true,
        underline = true,
        update_in_insert = false,
    })

    -- Customise sensible builtin LSP keymaps
    vim.keymap.set({ "n", "i" }, maps.lsp.prev_line_diags, function() vim.diagnostic.jump({ count=-1, float = true }) end, { desc = "Prev Diag" })
    vim.keymap.set({ "n", "i" }, maps.lsp.next_line_diags, function() vim.diagnostic.jump({ count=1, float = true }) end, { desc = "Next Diag" })
    vim.keymap.set({ "n" }, maps.lsp.toggle_inlay_hints, function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints" })
    vim.keymap.set({ "n" }, maps.lsp.open_diags_float, vim.diagnostic.open_float, { desc = "Show Line Diags" })
    vim.keymap.set({ "n" }, maps.lsp.next_error, function() vim.diagnostic.jump({ count=1, severity=vim.diagnostic.severity.ERROR }) end, { desc = "Next Error" })
    vim.keymap.set({ "n" }, maps.lsp.prev_error, function()  vim.diagnostic.jump({ count=-1, severity=vim.diagnostic.severity.ERROR }) end, { desc = "Prev Error" })
    vim.keymap.set({ "n" }, maps.lsp.next_warning, function() vim.diagnostic.jump({ count=1, severity=vim.diagnostic.severity.WARN }) end, { desc = "Next Warning" })
    vim.keymap.set({ "n" }, maps.lsp.prev_warning, function() vim.diagnostic.jump({ count=-1, severity=vim.diagnostic.severity.WARN }) end, { desc = "Prev Warning" })
    vim.keymap.set({ "n" }, maps.lsp.show_doc_references, vim.lsp.buf.document_highlight, { desc = "Show Doc Refs" })
    vim.keymap.set({ "n" }, maps.lsp.clear_doc_references, vim.lsp.buf.clear_references, { desc = "Clear Doc Refs" })
    vim.keymap.set({ "n" }, maps.lsp.send_diags_to_quickfix, vim.diagnostic.setqflist, { desc = "Send Diags to QF" })

    -- Enable LSP-powered formatting if available
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/formatting') then
        local _format_buffer = function()
            vim.lsp.buf.format({ bufnr = args.buf, async = true })
            vim.notify("Formatted current buffer", vim.log.levels.INFO, { title = "LSP" })
        end
        vim.keymap.set('n', maps.lsp.format_doc, _format_buffer, { desc = 'LSP: Format current buffer', buffer = args.buf })
        vim.keymap.set('n', maps.lsp.shortcuts.format_doc, _format_buffer, { desc = 'LSP: Format current buffer', buffer = args.buf })
    end

    -- Enable LSP-powered _range_ formatting if available
    if client:supports_method('textDocument/rangeFormatting') then
        local _format_range = function()
            vim.lsp.buf.format({ bufnr = args.buf, async = true })
            vim.notify("Formatted visual selection", vim.log.levels.INFO, { title = "LSP" })
        end
        vim.keymap.set('x', maps.lsp.format_range, _format_range, { desc = 'LSP: Format visual selection', buffer = args.buf })
        vim.keymap.set('x', maps.lsp.shortcuts.format_range, _format_range, { desc = 'LSP: Format visual selection', buffer = args.buf })
    end

    -- Configure rounded borders
    local opts = { buffer = args.buf, silent = true }

    -- Setup hover with border
    vim.keymap.set('n', maps.lsp.hover, function()
        vim.lsp.buf.hover({ border = 'rounded' })
    end, vim.tbl_extend('force', opts, { desc = 'LSP Hover' }))

    -- Setup signature help with border
    vim.keymap.set('i', maps.lsp.signature_help, function()
        vim.lsp.buf.signature_help({ border = 'rounded' })
    end, vim.tbl_extend('force', opts, { desc = 'LSP Signature Help' }))

    -- LSP client capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- ... extend to handle autocomplete (saghen/blink.cmp)
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

  end,
})

