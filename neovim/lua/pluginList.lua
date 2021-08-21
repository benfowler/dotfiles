local plugin_status = require("pluginsEnabled").plugin_status

local present, _ = pcall(require, "packerInit")
local packer
if present then
   packer = require "packer"
else
   return false
end

local use = packer.use


return packer.startup(function()
   use {
      "wbthomason/packer.nvim",
      event = "VimEnter",
   }

   -- tmux integration
   use {
      "christoomey/vim-tmux-navigator",
      disable = not plugin_status.vim_tmux_navigator,
      after = "packer.nvim",
      setup = function()
         require("mappings").vim_tmux_navigator()
      end,
   }

   -- File managmeent
   use {
      "kyazdani42/nvim-tree.lua",
      cmd = "NvimTreeToggle",
      config = function()
         require "plugins.nvimtree"
      end,
      setup = function()
         require("mappings").nvimtree()
      end,
   }

   use {
      "kyazdani42/nvim-web-devicons"
   }

   use {
      "nvim-lua/plenary.nvim",
      after = "packer.nvim",
   }

   -- Theme
   use {
      "arcticicestudio/nord-vim",
      config = function()
         require "plugins.nord"
      end,
   }

   -- Git support
   use {
      "lewis6991/gitsigns.nvim",
      disable = not plugin_status.gitsigns,
      after = "plenary.nvim",
      config = function()
         require "plugins.gitsigns"
      end,
   }

   use {
      "tpope/vim-fugitive",
      disable = not plugin_status.vim_fugitive,
      cmd = {
         "Git",
      },
      setup = function()
         require("mappings").fugitive()
      end,
   }
end)
