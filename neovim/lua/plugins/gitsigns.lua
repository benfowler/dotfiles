local present, gitsigns = pcall(require, "gitsigns")
if not present then
    return
end

-- Keybindings
local mappings = require("mappings").user_map.gitsigns

gitsigns.setup {
    signs = {
        add = { text = "│", numhl = "GitSignsAddNr" },
        change = { text = "│", numhl = "GitSignsChangeNr" },
        delete = { text = "_", numhl = "GitSignsDeleteNr" },
        topdelete = { text = "‾", numhl = "GitSignsDeleteNr" },
        changedelete = { text = "~", numhl = "GitSignsChangeNr" },
    },
    numhl = false,
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,
        ["n " .. mappings.next_hunk] = {
            expr = true,
            "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'",
        },
        ["n " .. mappings.prev_hunk] = {
            expr = true,
            "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'",
        },
        ["n " .. mappings.stage_hunk] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ["n " .. mappings.undo_stage_hunk] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ["n " .. mappings.reset_hunk] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ["n " .. mappings.preview_hunk] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ["n " .. mappings.blame_line] = '<cmd>lua require"gitsigns".blame_line()<CR>',
    },
    watch_gitdir = {
        interval = 100,
    },
    sign_priority = 5,
    status_formatter = nil, -- Use default
}
