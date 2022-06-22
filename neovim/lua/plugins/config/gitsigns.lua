local present, gitsigns = pcall(require, "gitsigns")
if not present then
    return
end

-- Keybindings
local mappings = require("mappings").user_map.gitsigns

local M = {}

local gitsigns_config_last_seen_foldcolumn_val = vim.o.foldcolumn

M.configure = function()

    -- Adaptive Git change indicators -- if folds are visible, then centre the
    -- mark between the fold and number columns

    local git_add_change_sign = "▎ "

    if vim.o.foldcolumn ~= "0" then
        git_add_change_sign = " ▎"
    end

    gitsigns.setup {
        -- Attach handler is required to configure at buffer-level
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', mappings.next_hunk, function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            map('n', mappings.prev_hunk, function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, { expr = true })

            -- Actions
            map({ 'n', 'v' }, mappings.stage_hunk, ':Gitsigns stage_hunk<CR>')
            map({ 'n', 'v' }, mappings.reset_hunk, ':Gitsigns reset_hunk<CR>')
            map('n', mappings.preview_hunk, gs.preview_hunk)
            map('n', mappings.blame_line, function() gs.blame_line { full = true } end)
            map('n', mappings.diffthis, gs.diffthis)
            map('n', mappings.undo_stage_hunk, gs.undo_stage_hunk)
            map('n', mappings.stage_buffer, gs.stage_buffer)
            map('n', mappings.reset_buffer, gs.reset_buffer)
            map('n', mappings.toggle_current_line_blame, gs.toggle_current_line_blame)
            map('n', mappings.diffthis2, function() gs.diffthis('~') end)
            map('n', mappings.toggle_deleted, gs.toggle_deleted)

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end,
        signs = {
            add = { text = git_add_change_sign, numhl = "GitSignsAddNr" },
            change = { text = git_add_change_sign, numhl = "GitSignsChangeNr" },
            delete = { text = "_", numhl = "GitSignsDeleteNr" },
            topdelete = { text = "‾", numhl = "GitSignsDeleteNr" },
            changedelete = { text = "~", numhl = "GitSignsChangeNr" },
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

    -- Force refresh of signcolumn, if foldcolumn has changed since last time configure() executed
    if gitsigns_config_last_seen_foldcolumn_val ~= vim.o.foldcolumn then
        gitsigns.toggle_signs()
        gitsigns.toggle_signs()
    end

    gitsigns_config_last_seen_foldcolumn_val = vim.o.foldcolumn
end

return M
