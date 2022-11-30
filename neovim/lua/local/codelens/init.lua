-- Override method from built-in LSP, to permit customisation of the way
-- code lenses are shown.

-- Set default sign
local SIGN_GROUP = "codelens-slightly-nicer"
local SIGN_NAME = "CodeLensSign"

if vim.tbl_isempty(vim.fn.sign_getdefined(SIGN_NAME)) then
    vim.fn.sign_define(SIGN_NAME, { text = " ", texthl = "LspCodeLens", numhl = "LspCodeLens" })
end

local api = vim.api
local namespaces = vim.lsp.codelens.__namespaces

--- Display the lenses using virtual text
---
---@param lenses table of lenses to display (`CodeLens[] | null`)
---@param bufnr number
---@param client_id number
local function display_code_lens(lenses, bufnr, client_id)
    -- (bjf, 11/06/2022: my additions here)
    vim.fn.sign_unplace(SIGN_GROUP, { buffer = bufnr })

    if not lenses or not next(lenses) then
        return
    end
    local lenses_by_lnum = {}
    for _, lens in pairs(lenses) do
        local line_lenses = lenses_by_lnum[lens.range.start.line]
        if not line_lenses then
            line_lenses = {}
            lenses_by_lnum[lens.range.start.line] = line_lenses
        end
        table.insert(line_lenses, lens)
    end
    local ns = namespaces[client_id]
    local num_lines = api.nvim_buf_line_count(bufnr)
    for i = 0, num_lines do
        local line_lenses = lenses_by_lnum[i] or {}
        api.nvim_buf_clear_namespace(bufnr, ns, i, i + 1)
        local chunks = {}
        local num_line_lenses = #line_lenses

        -- (bjf, 11/06/2022: my additions here)
        if num_line_lenses > 0 then
            -- Sign
            vim.fn.sign_place(i + 1, SIGN_GROUP, SIGN_NAME, bufnr, { lnum = i + 1, priority = 8 })
            -- Virtual text: padding and bullet
            table.insert(chunks, { "    ", "LspCodeLens" })
        end

        table.sort(line_lenses, function(a, b)
            return a.range.start.character < b.range.start.character
        end)
        for j, lens in ipairs(line_lenses) do
            local text = lens.command and lens.command.title or "Unresolved lens ..."
            table.insert(chunks, { text, "LspCodeLens" })
            if j < num_line_lenses then
                table.insert(chunks, { " | ", "LspCodeLensSeparator" })
            end
        end
        if #chunks > 0 then
            api.nvim_buf_set_extmark(bufnr, ns, i, 0, {
                virt_text = chunks,
                hl_mode = "combine",
            })
        end
    end
end

-- Override LSP 'display codelens' functionality with our own
vim.lsp.codelens.display = display_code_lens
