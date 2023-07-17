local maps = require("config.keymaps")
local util = require("util")

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		lazy = true,
		config = function()
			-- This is where you modify the settings for lsp-zero
			-- Note: autocompletion settings will not take effect

			local lsp = require("lsp-zero").preset({})

			-- Keymaps
			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
			end)

			-- Servers
			lsp.ensure_installed({
				"bashls",
				"clangd",
				"emmet_ls",
				"gopls",
				"jsonls",
				"lua_ls",
				"lemminx",
				"texlab",
				"tsserver",
			})

			-- Custom gutter icons
			lsp.set_sign_icons(util.diagnostic_icons.filled)

			lsp.setup()
		end,
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			-- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
			-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

			require("lsp-zero.cmp").extend()

			-- And you can configure cmp even more, if you want to.
			local cmp = require("cmp")
			local cmp_action = require("lsp-zero.cmp").action()

			cmp.setup({
				mapping = {
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
				},
			})
		end,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "williamboman/mason-lspconfig.nvim" },
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "j-hui/fidget.nvim" },
		},
		keys = {
			{ maps.lsp.lspinfo, ":LspInfo<cr>", desc = "LspInfo" },
		},

		config = function()
			-- This is where all the LSP shenanigans will live

			local lsp = require("lsp-zero")

			lsp.on_attach(function(client, bufnr)
				lsp.default_keymaps({ buffer = bufnr })
			end)

			-- (Optional) Configure lua language server for neovim
			require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

			lsp.setup()
		end,
	},

	-- Show LSP server activity as an overlay
	{
		"j-hui/fidget.nvim",
    tag = "legacy",
		opts = {
			text = {
				spinner = "dots",
				done = " ",
				completed = "Done",
			},
			timer = {
				fidget_decay = 3600,
				task_decay = 1800,
			},
			window = {
				blend = 5,
			},
		},
	},
}
