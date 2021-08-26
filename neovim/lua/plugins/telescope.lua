local present, telescope = pcall(require, "telescope")
if not present then
   return
end

local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')


telescope.setup {
   defaults = {
      mappings = {
        -- INSERT MODE
        i = { 
          ["<esc>"] = actions.close,          -- I have no use for Normal mode!
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.preview_scrolling_up,
          ["<C-p>"] = actions.preview_scrolling_down,
        },
      },
      vimgrep_arguments = {
         "rg",
         "--color=never",
         "--no-heading",
         "--with-filename",
         "--line-number",
         "--column",
         "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "❯ ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_config = {
         horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
         },
         vertical = {
            mirror = false,
         },
         width = 0.87,
         height = 0.80,
         preview_cutoff = 120,
      },
      file_sorter = sorters.get_fuzzy_file,
      file_ignore_patterns = {},
      generic_sorter = sorters.get_generic_fuzzy_sorter,
      path_display = { "absolute" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = previewers.vim_buffer_cat.new,
      grep_previewer = previewers.vim_buffer_vimgrep.new,
      qflist_previewer = previewers.vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = previewers.buffer_previewer_maker,
   },
   pickers = {
      buffers = {
         sort_lastused = true,
         theme = "dropdown",
         mappings = {
            i = {
               ["<c-d>"] = actions.delete_buffer
            }
         },
      },
      find_files = {
        sort_lastused = true,
        theme = "ivy",
      }, 
      file_browser = {
        theme = "ivy",
      }, 
      git_files = {
        sort_lastused = true,
        theme = "ivy",
      }, 
      git_branches = {
        sort_lastused = true,
        theme = "ivy",
        layout_config = {
            height = 0.25,
        }
      }, 
      git_commits = {
        sort_lastused = true,
        theme = "ivy",
      }, 
      git_bcommits = {
        sort_lastused = true,
        theme = "ivy",
      }, 
      git_status = {
        sort_lastused = true,
        theme = "ivy",
      }, 
      git_stash = {
        sort_lastused = true,
        theme = "ivy",
        layout_config = {
            height = 0.25,
        }
      }, 
      colorscheme = {
        sort_lastused = true,
        theme = "dropdown",
      }, 
      oldfiles = {
        sort_lastused = true,
        theme = "ivy",
      },
      spell_suggest = {
        theme = "cursor",
        layout_config = {
            height = 10,
            width = 40
        }
      },
      lsp_reference = {
        theme = "cursor"
      },
      lsp_code_actions = {
        theme = "cursor"
      },
      lsp_implementations = {
        theme = "cursor"
      },
      lsp_definitions = {
        theme = "cursor"
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

require("telescope").load_extension "ultisnips"
require('telescope').load_extension('heading') 

