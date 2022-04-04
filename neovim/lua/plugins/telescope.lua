local present, telescope = pcall(require, "telescope")
if not present then
    return
end

local actions = require "telescope.actions"
local previewers = require "telescope.previewers"

telescope.setup {
    defaults = {
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
    },
    pickers = {
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
        spell_suggest = {
            theme = "cursor",
            layout_config = {
                height = 10,
                width = 40,
            },
        },
        lsp_code_actions = {
            theme = "cursor",
        },
        diagnostics = {
            theme = "ivy",
        },
        lsp_definitions = {
            theme = "ivy",
        },
        lsp_type_definitions = {
            theme = "ivy",
        },
        lsp_implementations = {
            theme = "ivy",
        },
        lsp_references = {
            theme = "ivy",
        },
        lsp_workspace_symbols = {
            theme = "ivy",
        },
        lsp_document_symbols = {
            theme = "ivy",
        },
        lsp_reference = {
            theme = "ivy",
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

telescope.load_extension "heading"
telescope.load_extension "fzf"
telescope.load_extension "luasnip"

