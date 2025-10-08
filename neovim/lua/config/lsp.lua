
local maps = require "config.keymaps"
local util = require "util"

local lsp_icons = util.diagnostic_icons.outline


-- Enabled language servers
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('texlab')


-- Global defaults
vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
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
            header = false,
            border = 'rounded',
            focusable = true,
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
                [dg_error] = nil, [dg_warn] = nil, [dg_info] = nil, [dg_hint] = nil,
            },

        },
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        -- virtual_lines = {
        --     current_line = true,
        -- },
        virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "󰓛",
        },
    })

    -- Customise sensible builtin LSP keymaps
    vim.keymap.set({ "n", "i" }, maps.lsp.prev_line_diags, function() vim.diagnostic.jump({ count=-1, float = true }) end, { desc = "prev line diag" })
    vim.keymap.set({ "n", "i" }, maps.lsp.next_line_diags, function() vim.diagnostic.jump({ count=1, float = true }) end, { desc = "next line diag" })
    vim.keymap.set({ "n" }, maps.lsp.toggle_inlay_hints, function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints" })

    -- LSP capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- ... extend to handle autocomplete (saghen/blink.cmp)
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, false))

    -- ... add my own capabilities
    capabilities = vim.tbl_deep_extend('force', capabilities, {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
        }
    })

    -- Configure rounded corners for LSP floats only
    local _open_floating_preview = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or 'rounded' -- or whichever border kind you want
        return _open_floating_preview(contents, syntax, opts, ...)
    end

  end,
})

