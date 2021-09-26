local present, tree_c = pcall(require, "nvim-tree.config")
if not present then
    return
end


-- Auto-close file explorer when quitting, in case a single buffer is left
vim.cmd([[ autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'nvimtree') | q | endif ]])


local g = vim.g

vim.o.termguicolors = true

g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_ignore = { ".git", ".cache" }
g.nvim_tree_gitignore = 1
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_allow_resize = 1
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names

g.nvim_tree_add_trailing = 1 -- 0 by default, append a trailing slash to folder names
g.nvim_tree_group_empty = 1 -- 0 by default, compact folders that only contain a single folder into one node in the file tree
g.nvim_tree_lsp_diagnostics = 1 -- 0 by default, will show LSP diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
g.nvim_tree_disable_window_picker = 1

g.nvim_tree_icon_padding = "  "
g.nvim_tree_respect_buf_cwd = 1

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
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = true,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
}

