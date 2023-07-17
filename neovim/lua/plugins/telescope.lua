local maps = require("config.keymaps")

return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"plenary.nvim",

			-- Extensions
			"crispgm/telescope-heading.nvim",
		},
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = "❯ ",
				path_display = { "smart" },
				color_devicons = true,
				sort_lastused = true,
				i = {
					["<c-t>"] = function(...)
						return require("trouble.providers.telescope").open_with_trouble(...)
					end,
					["<a-t>"] = function(...)
						return require("trouble.providers.telescope").open_selected_with_trouble(...)
					end,
					-- ["<a-i>"] = function()
					-- 	return require("telescope.builtin").find_files({ jo_ignore = true })
					-- end,
					-- ["<a-h>"] = function()
					-- 	return require("telescope.builtin").find_files({ hidden = true })
					-- end,
					["<C-Down>"] = function(...)
						return require("telescope.actions").cycle_history_next(...)
					end,
					["<C-Up>"] = function(...)
						return require("telescope.actions").cycle_history_prev(...)
					end,
					["<C-f>"] = function(...)
						return require("telescope.actions").preview_scrolling_down(...)
					end,
					["<C-b>"] = function(...)
						return require("telescope.actions").preview_scrolling_up(...)
					end,
				},
				n = {
					["q"] = function(...)
						return require("telescope.actions").close(...)
					end,
				},
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
				diagnostics = {
					theme = "dropdown",
				},
				lsp_definitions = {
					theme = "dropdown",
				},
				lsp_type_definitions = {
					theme = "dropdown",
				},
				lsp_implementations = {
					theme = "dropdown",
				},
				lsp_references = {
					theme = "dropdown",
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
		},
		keys = {
			-- Fast shortcuts to core Vim state
			{ maps.telescope.telescope, ":Telescope<CR>", silent = true, desc = "Telescope" },
			{ maps.telescope.files, ":Telescope find_files<CR>", silent = true, desc = "Fuzzy finder" },
			{ maps.telescope.buffers, ":Telescope buffers<CR>", silent = true, desc = "Buffers" },
			{ maps.telescope.marks, ":Telescope marks<CR>", silent = true, desc = "Marks" },
			{ maps.telescope.registers, ":Telescope registers<CR>", silent = true, desc = "Registers" },
			{ maps.telescope.jumplist, ":Telescope jumplist<CR>", silent = true, desc = "Jumplist" },
			{ maps.telescope.help_tags, ":Telescope help_tags<CR>", silent = true, desc = "Help tags" },
			{ maps.telescope.man_pages, ":Telescope man_pages<CR>", silent = true, desc = "Man pages" },
			{ maps.telescope.keymaps, ":Telescope keymaps<CR>", silent = true, desc = "Keymaps" },
			{ maps.telescope.highlights, ":Telescope highlights<CR>", silent = true, desc = "Highlights" },
			{ maps.telescope.autocommands, ":Telescope autocommands<CR>", silent = true, desc = "Autocmds" },

      -- Pick snippet to preview and insert
      -- stylua: ignore
      { maps.telescope.select_snippet, ":silent! Telescope luasnip theme=get_dropdown layout_config={'height':0.5,'width':120}<CR>", desc = "Telescope pick snippet" },
			-- LSP
			{ maps.telescope.lsp_diagnostics, ":Telescope diagnostics<CR>", desc = "Diagnostics" },
			{
				maps.telescope.lsp_diagnostics_doc,
				":Telescope diagnostics bufnr=0<CR>",
				desc = "Diagnostics document",
			},

			{ maps.telescope.lsp_symbols, ":Telescope lsp_workspace_symbols<CR>", desc = "Symbols" },
			{ maps.telescope.lsp_symbols_doc, ":Telescope lsp_document_symbols<CR>", desc = "Symbols" },

			{ maps.telescope.lsp_definitions, ":Telescope lsp_definitions<CR>", desc = "Definitions" },
			{ maps.telescope.lsp_implementations, ":Telescope lsp_implementations<CR>", desc = "Implementations" },
			{ maps.telescope.lsp_references, ":Telescope lsp_references<CR>", desc = "References" },
			{ maps.telescope.lsp_type_definitions, ":Telescope lsp_type_definitions<CR>", desc = "Type definitions" },

			-- Git objects
			{ maps.telescope.git_commits, ":Telescope git_commits<CR>", desc = "Git commits" },
			{ maps.telescope.git_bcommits, ":Telescope git_bcommits<CR>", desc = "Git branch commits" },
			{ maps.telescope.git_branches, ":Telescope git_branches<CR>", desc = "Git branches" },
			{ maps.telescope.git_stash, ":Telescope git_stash<CR>", desc = "Git stashes" },
			{ maps.telescope.git_files, ":Telescope git_files<CR>", desc = "Git files" },

			-- Markdown headings navigation
			{
				maps.telescope.markdown_headings,
				":Telescope heading theme=get_dropdown<cr>",
				desc = "Headings (Telescope)",
				silent = true,
			},

			-- Use Telescope to pick spelling suggestions
			{
				maps.telescope.spell_suggest,
				":Telescope spell_suggest<CR>",
				desc = "Telescope spell suggest",
				silent = true,
			},
		},
		config = function()
			require("telescope").load_extension("heading")
		end,
	},
}
