-- FUZZY FINDER (FZF)
--
local present, fzf = pcall(require, "fzf.vim")

if not present then
    return
end


-- TODO: do lots of porting to idiomatic Lua configuration, once full API is ready
--
-- Neither 1) autocmds or 2) user-defined commands have Neovim Lua API yet

local env = vim.env
local g = vim.g

-- General config options
g.fzf_buffers_jump = 1 -- jump to the existing window if possible
g.fzf_preview_window = "" -- none by default
g.fzf_prefer_tmux = 1

-- FZF mode tweaks
env.FZF_DEFAULT_OPTS = " --layout=reverse --border --margin=1,1"

-- This is the default extra key bindings
g.fzf_action = {
    ["ctrl-t"] = "tab split",
    ["ctrl-x"] = "split",
    ["ctrl-v"] = "vsplit",
}

-- Pull colours from current theme
g.fzf_colors = {
    ["fg"] = { "fg", "FzfFg" },
    ["bg"] = { "bf", "FzfBg" },
    ["hl"] = { "fg", "FzfHl" },
    ["fg+"] = { "fg", "FzfFg_" },
    ["bg+"] = { "bg", "FzfBg_" },
    ["hl+"] = { "fg", "FzfHl_" },
    ["info"] = { "fg", "FzfInfo" },
    ["border"] = { "fg", "FzfBorder" },
    ["prompt"] = { "fg", "FzfPrompt" },
    ["pointer"] = { "fg", "FzfPointer" },
    ["marker"] = { "fg", "FzfMarker" },
    ["spinner"] = { "fg", "FzfSpinner" },
    ["header"] = { "fg", "FzfHeader" },
}

-- Window setups for FZF
g.fzf_custom_win_files = {
    window = {
        width = 0.6,
        height = 0.75,
        border = "rounded",
        highlight = "Comment",
    },
}

g.fzf_custom_win_buffers = {
    window = {
        width = 0.4,
        height = 0.5,
        border = "rounded",
        highlight = "Comment",
    },
    placeholder = '{1}',
}

g.fzf_custom_win_windows = {
    window = {
        width = 0.4,
        height = 0.5,
        border = "rounded",
        highlight = "Comment",
    },
    placeholder = '{1}',
    options = "--prompt='Win> '",
}

g.fzf_custom_win_grep = {
    window = {
        width = 0.9,
        height = 0.75,
        border = "rounded",
        highlight = "Comment",
    },
}

-- How are we invoking rg?
g.fzf_rg_cmd = 'rg --column --line-number --no-heading --color=always --smart-case -- '


-- stylua: ignore
vim.cmd [[

" Pop up Fuzzy Finder in a window when using Neovim
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, g:fzf_custom_win_files, <bang>0)
command! -bang -nargs=? -complete=dir History call fzf#vim#history(g:fzf_custom_win_files, <bang>0)
command! -bang -nargs=? -complete=dir GFiles call fzf#vim#gitfiles(<q-args>, g:fzf_custom_win_files, <bang>0)
command! -bang -nargs=? -complete=dir GitFiles call fzf#vim#gitfiles(<q-args>, g:fzf_custom_win_files, <bang>0)
command! -bang -nargs=? -complete=buffer Buffers call fzf#vim#buffers(<q-args>, g:fzf_custom_win_buffers, <bang>0)
command! -bar -bang Windows call fzf#vim#windows(g:fzf_custom_win_windows, <bang>0)
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, g:fzf_custom_win_grep, <bang>0)
command! -bang -nargs=* Rg call fzf#vim#grep( g:fzf_rg_cmd.shellescape(<q-args>), 1, g:fzf_custom_win_grep, <bang>0)
]]

