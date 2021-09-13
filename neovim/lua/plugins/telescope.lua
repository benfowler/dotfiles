local present, telescope = pcall(require, "telescope")
if not present then
    return
end

local actions = require "telescope.actions"
local previewers = require "telescope.previewers"

telescope.setup {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        mappings = {
            -- INSERT MODE
            i = {
                ["<esc>"] = actions.close, -- I have no use for Normal mode!
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-p>"] = actions.preview_scrolling_up,
                ["<C-n>"] = actions.preview_scrolling_down,
            },
        },
        prompt_prefix = "   ",
        selection_caret = "❯ ",
        path_display = { "smart" },
        color_devicons = true,
        sort_lastused = true,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = previewers.buffer_previewer_maker,
    },
    pickers = {
        buffers = {
            theme = "dropdown",
            mappings = {
                i = {
                    ["<c-d>"] = actions.delete_buffer,
                },
            },
        },
        find_files = {
            theme = "ivy",
        },
        file_browser = {
            theme = "ivy",
        },
        git_files = {
            theme = "ivy",
        },
        git_branches = {
            theme = "ivy",
            layout_config = {
                height = 0.25,
            },
        },
        git_commits = {
            theme = "ivy",
        },
        git_bcommits = {
            theme = "ivy",
        },
        git_status = {
            theme = "ivy",
        },
        git_stash = {
            theme = "ivy",
            layout_config = {
                height = 0.25,
            },
        },
        colorscheme = {
            theme = "dropdown",
        },
        oldfiles = {
            theme = "ivy",
        },
        spell_suggest = {
            theme = "cursor",
            layout_config = {
                height = 10,
                width = 40,
            },
        },
        lsp_reference = {
            theme = "cursor",
        },
        lsp_code_actions = {
            theme = "cursor",
        },
        lsp_implementations = {
            theme = "cursor",
        },
        lsp_definitions = {
            theme = "cursor",
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = false, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
}

require("telescope").load_extension "heading"
require("telescope").load_extension "fzf"
require("telescope").load_extension "luasnip"
