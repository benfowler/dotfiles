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

   -- Editing features
   use {
      "qpkorr/vim-bufkill",   -- 'BD' to kill a buffer without closing a split
      after = "packer.nvim",
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
      "tpope/vim-eunuch",
      after = "packer.nvim",
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

   -- Misc plugins
   use {
      "terrortylor/nvim-comment",
      disable = not plugin_status.nvim_comment,
      cmd = "CommentToggle",
      config = function()
         require("plugins.others").comment()
      end,
      setup = function()
         require("mappings").comment_nvim()
      end,
   }

   use {
      "Pocco81/TrueZen.nvim",
      disable = not plugin_status.truezen_nvim,
      cmd = {
         "TZAtaraxis",
         "TZMinimalist",
         "TZFocus",
      },
      config = function()
         require "plugins.zenmode"
      end,
      setup = function()
         require("mappings").truezen()
      end,
   }

end)
