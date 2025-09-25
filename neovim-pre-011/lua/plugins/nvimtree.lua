local maps = require "config.keymaps"

return {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
        { maps.nvimtree.treetoggle, ":NvimTreeToggle<CR>", silent = true, desc = "NvimTree goggle" },
        { maps.nvimtree.treefocus, ":NvimTreeFocus<CR>", silent = true, desc = "NvimTree focus file" },
    },
    opts = {
        respect_buf_cwd = true,
        view = {
            width = 30,
        },
        renderer = {
            add_trailing = true,
            group_empty = true,
            highlight_git = true,
            indent_markers = {
                enable = false,
            },
            icons = {
                show = {
                    git = false,
                },
                glyphs = {
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "➜",
                        untracked = "★",
                        deleted = "",
                        ignored = "◌",
                    },
                },
            },
            special_files = { "Cargo.toml", "Makefile", "pom.xml", "package.json", "Dockerfile" },
        },
        update_focused_file = {
            enable = true,
            update_cwd = false,
            ignore_list = {},
        },
        system_open = {
            cmd = nil,
            args = {},
        },
        diagnostics = {
            enable = true,
            icons = {
                error = require("util").diagnostic_icons.filled.error,
                warning = require("util").diagnostic_icons.filled.warn,
                info = require("util").diagnostic_icons.filled.info,
                hint = require("util").diagnostic_icons.filled.hint,
            },
        },
    },
}
