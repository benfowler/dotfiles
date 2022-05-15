-- Locally-defined 'null-ls' (loopback lanuage server) source for Cloudformation (cfn-lint)

local null_ls = require "null-ls"
local null_helpers = require "null-ls.helpers"

local M = { }

M.diagnostics = { }

M.diagnostics.cfn_lint = {
    name = "cfn-lint",
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "cloudformation" },
    generator = null_helpers.generator_factory {
        command = "cfn-lint",
        args = { "--format", "parseable", "-" },
        format = "line",
        to_stdin = true,
        from_stderr = true,
        on_output = function(line, _)
            local row, col, end_row, end_col, code, message = line:match ":(%d+):(%d+):(%d+):(%d+):(.*):(.*)"
            local severity = null_helpers.diagnostics.severities["error"]

            if message == nil then
                return nil
            end

            if vim.startswith(code, "E") then
                severity = null_helpers.diagnostics.severities["error"]
            elseif vim.startswith(code, "W") then
                severity = null_helpers.diagnostics.severities["warning"]
            else
                severity = null_helpers.diagnostics.severities["information"]
            end

            return {
                message = message,
                code = code,
                row = row,
                col = col,
                end_col = end_col,
                end_row = end_row,
                severity = severity,
                source = "cfn-lint",
            }
        end,
    },
}

return M

