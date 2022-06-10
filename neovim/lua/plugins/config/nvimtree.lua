local present, _ = pcall(require, "nvim-tree.config")
if not present then
    return
end

local lsp_icons = require("utils").diagnostic_icons.outline


-- Breaking change: authors moved a bunch of config into new setup() function
require 'nvim-tree'.setup {
    respect_buf_cwd = true,
    view = {
        width = 30,
    },
    renderer = {
        add_trailing = true,
        group_empty = true,
        highlight_git = true,
        indent_markers = {
            enable = true,
        },
        icons = {
            show = {
                git = false,
            },
            padding = " ",
            glyphs = {
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
            },
        },
        special_files = { "Cargo.toml", "Makefile", "pom.xml", "package.json", "Dockerfile" },
    },
    update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {}
    },
    system_open = {
        cmd = nil,
        args = {}
    },
    diagnostics = {
        enable = true,
        icons = {
            error = lsp_icons.error,
            warning = lsp_icons.warn,
            info = lsp_icons.info,
            hint = lsp_icons.hint,
        },
    }
}
