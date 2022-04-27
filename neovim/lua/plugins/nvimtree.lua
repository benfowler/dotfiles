local present, _ = pcall(require, "nvim-tree.config")
if not present then
    return
end

local lsp_icons = require("utils").diagnostic_icons.outline


-- Auto-close file explorer when quitting, in case a single buffer is left
vim.cmd [[ autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif ]]


local g = vim.g

vim.o.termguicolors = true

g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_allow_resize = 1
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_refresh_wait = 500

g.nvim_tree_add_trailing = 1 -- 0 by default, append a trailing slash to folder names
g.nvim_tree_group_empty = 1 -- 0 by default, compact folders that only contain a single folder into one node in the file tree

g.nvim_tree_icon_padding = "  "
g.nvim_tree_respect_buf_cwd = 1

vim.api.nvim_exec([[
    augroup NvimTreeOptions
        autocmd BufEnter NvimTree set cursorline
        autocmd BufEnter NvimTree hi clear NvimTreeExecFile
        autocmd BufEnter NvimTree hi clear NvimTreeImageFile
    augroup END
    ]], false)


-- List of filenames that gets highlighted with NvimTreeSpecialFile
g.nvim_tree_special_files = {
    ["Cargo.toml"] = true,
    Makefile = true,
    ["pom.xml"] = true,
    ["package.json"] = true,
    ["Dockerfile"] = true,
}

g.nvim_tree_show_icons = {
    git = 0,
    folders = 1,
    files = 1,
    -- folder_arrows = 1
}

g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "",
        staged = "",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌",
    },
    folder = {
        -- Disable indent_markers option to get arrows working or if you want both
        -- arrows and indent then just add the arrow icons in front ofthe default
        -- and opened folders below!
        -- arrow_open = "",
        -- arrow_closed = "",
        default = "",
        open = "",
        empty = "", -- 
        empty_open = "",
        -- default = "",
        -- open = "",
        -- empty = "", -- 
        -- empty_open = "",
        symlink = "",
        symlink_open = "",
        -- symlink_open = "",
    },
}


-- Breaking change: authors moved a bunch of config into new setup() function
require 'nvim-tree'.setup {
    disable_netrw         = false,
    hijack_netrw          = true,
    open_on_setup         = false,
    ignore_ft_on_setup    = {},
    open_on_tab           = false,
    hijack_cursor         = false,
    update_cwd            = false,
    renderer              = {
        indent_markers = {
            enable = true,
        },
    },
    update_focused_file   = {
        enable      = true,
        update_cwd  = false,
        ignore_list = {}
    },
    system_open           = {
        cmd  = nil,
        args = {}
    },
    diagnostics           = {
        enable       = true,
        show_on_dirs = true,
        icons        = {
            error = lsp_icons.error,
            warning = lsp_icons.warn,
            info = lsp_icons.info,
            hint = lsp_icons.hint,
        },
    }
}
