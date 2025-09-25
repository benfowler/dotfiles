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
      { maps.lsp.declaration, vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { maps.lsp.type_definitions, "<cmd>Telescope lsp_type_definitions<cr>", desc = "Goto T[y]pe Definition" },
      { maps.lsp.prev_line_diags, function() vim.diagnostic.jump({ count=-1, float = true }) end, desc = "Prev Line Diag" },
      { maps.lsp.next_line_diags, function() vim.diagnostic.jump({ count=1, float = true }) end, desc = "Next Line Diag" },
      { maps.lsp.next_error, function() vim.diagnostic.jump({ count=1, severity=vim.diagnostic.severity.ERROR }) end, desc = "Next Error" },
      { maps.lsp.prev_error,function()  vim.diagnostic.jump({ count=-1, severity=vim.diagnostic.severity.ERROR }) end, desc = "Prev Error" },
      { maps.lsp.next_warning,function()  vim.diagnostic.jump({ count=1, severity=vim.diagnostic.severity.WARN }) end, desc = "Next Warning" },
      { maps.lsp.prev_warning,function()  vim.diagnostic.jump({ count=-1, severity=vim.diagnostic.severity.WARN }) end, desc = "Prev Warning" },
      { maps.lsp.format_doc, format, desc = "Format Document", has = "documentFormatting" },
      { maps.lsp.format_range, format, desc = "Format Range", mode = "v", has = "documentRangeFormatting" },
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

return M
