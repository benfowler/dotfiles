-- Override legacy XmlIndentGet() after indent scripts have run.
vim.schedule(function()
    if vim.bo.filetype == 'xml' then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter.indent'.get_indent(v:lnum)"
    end
end)

-- p/P: paste then re-indent the pasted region using indentexpr (TS-aware for XML)
vim.keymap.set('n', 'p', 'p`[v`]=', { buffer = true, desc = 'Paste and re-indent' })
vim.keymap.set('n', 'P', 'P`[v`]=', { buffer = true, desc = 'Paste above and re-indent' })

-- Bracketed paste (terminal paste): re-indent after vim.paste() delivers the text.
local orig_paste = vim.paste
---@diagnostic disable-next-line: duplicate-set-field
vim.paste = function(lines, phase)
    local ret = orig_paste(lines, phase)
    if phase == -1 or phase == 3 then
        -- phase -1 = non-streaming single call; phase 3 = end of stream
        vim.schedule(function()
            if vim.bo.filetype == 'xml' then
                -- re-indent the lines that were just inserted
                local mark = vim.api.nvim_buf_get_mark(0, '[')
                local mark2 = vim.api.nvim_buf_get_mark(0, ']')
                vim.cmd(mark[1] .. ',' .. mark2[1] .. 'normal! ==')
            end
        end)
    end
    return ret
end
