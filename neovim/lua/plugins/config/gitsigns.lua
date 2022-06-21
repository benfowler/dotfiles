local present, gitsigns = pcall(require, "gitsigns")
if not present then
    return
end

-- Keybindings
local mappings = require("mappings").user_map.gitsigns

gitsigns.setup {
    signs = {
        add = { text = " ▎", numhl = "GitSignsAddNr" },
        change = { text = " ▎", numhl = "GitSignsChangeNr" },
        delete = { text = "_", numhl = "GitSignsDeleteNr" },
        topdelete = { text = "‾", numhl = "GitSignsDeleteNr" },
        changedelete = { text = "~", numhl = "GitSignsChangeNr" },
    },
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,
        ["n " .. mappings.next_hunk] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'", },
        ["n " .. mappings.prev_hunk] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'", },
        ["n " .. mappings.stage_hunk] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ["n " .. mappings.undo_stage_hunk] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ["n " .. mappings.reset_hunk] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ["n " .. mappings.preview_hunk] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ["n " .. mappings.blame_line] = '<cmd>lua require"gitsigns".blame_line()<CR>',
        ["n " .. mappings.quickfix] = '<cmd>lua require"gitsigns".setqflist()<CR>',
        ["n " .. mappings.diffthis] = '<cmd>lua require"gitsigns".diffthis()<CR>',
    },
    watch_gitdir = { interval = 2000, follow_files = true },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        noautocmd = true,
        row = 0,
        col = 1
    },
    trouble = true,
}
