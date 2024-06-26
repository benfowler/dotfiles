local M = {}

local maps = require "config.keymaps"

M._keys = nil

function M.get()
    local format = function()
        require("plugins.lsp.format").format { force = true }
    end
    if not M._keys then
    -- stylua: ignore
    M._keys =  {
      { maps.lsp.line_diags, vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { maps.lsp.info, "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { maps.lsp.definitions, "<cmd>Telescope lsp_definitions<cr>", desc = "Goto Definition", has = "definition" },
      { maps.lsp.references, "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { maps.lsp.declaration, vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { maps.lsp.implementations, "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { maps.lsp.type_definitions, "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
      { maps.lsp.signature_help, vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      { maps.lsp.signature_help_insert, vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
      { maps.lsp.next_line_diags, function() vim.diagnostic.goto_next({ float = true }) end, desc = "Line Diagnostics" },
      { maps.lsp.next_error, M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
      { maps.lsp.prev_error, M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
      { maps.lsp.next_warning, M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      { maps.lsp.prev_warning, M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
      { maps.lsp.format_doc, format, desc = "Format Document", has = "documentFormatting" },
      { maps.lsp.format_range, format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
      { maps.lsp.rename, vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { maps.lsp.code_action, vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      { maps.lsp.code_lens, function() vim.lsp.codelens.run() end, desc = "Run CodeLens" },
      { maps.lsp.toggle_inlay_hints, function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle Inlay Hints" },
      {
        maps.lsp.source_action,
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
        has = "codeAction",
      },

      -- Additional bindings for convenience
      { maps.lsp.shortcuts.format_doc, format, desc = "Format Document", has = "documentFormatting" },
      { maps.lsp.shortcuts.format_range, format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
      { maps.lsp.shortcuts.rename, vim.lsp.buf.rename, desc = "Rename", has = "rename" },
      { maps.lsp.shortcuts.code_action, vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
      {
        maps.lsp.shortcuts.source_action,
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
        has = "codeAction",
      }
    }
    end
    return M._keys
end

function M.on_attach(client, buffer)
    local Keys = require "lazy.core.handler.keys"
    local keymaps = {}

    for _, value in ipairs(M.get()) do
        local keys = Keys.parse(value)
        if keys[2] == vim.NIL or keys[2] == false then
            keymaps[keys.id] = nil
        else
            keymaps[keys.id] = keys
        end
    end

    for _, keys in pairs(keymaps) do
        if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
            local opts = Keys.opts(keys)
            ---@diagnostic disable-next-line: no-unknown
            opts.has = nil
            opts.silent = opts.silent ~= false
            opts.buffer = buffer
            vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
        end
    end
end

function M.diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go { severity = severity }
    end
end

return M
