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

   use {
      -- used by Packer, various Neovim plugins to do growl notifications
      "rcarriga/nvim-notify",
      after = "packer.nvim",
   }

   -- Editing features
   use {
      "qpkorr/vim-bufkill",   -- 'BD' to kill a buffer without closing a split
      after = "packer.nvim",
      cmd = { "BUN", "BD", "BW", "BB", "BF", "BA" },
   }

   use {
      "junegunn/vim-easy-align",
      after = "packer.nvim",
      cmd = {
         "EasyAlign",
         "EasyAlign!",
         "LiveEasyAlign",
      },
      setup = function()
         require("mappings").easy_align()
      end,
   }

   use {
      "tpope/vim-surround",
      after = "packer.nvim",
   }

   use {
      "mattn/emmet-vim",
      after = "packer.nvim",
   }

   use {
      "norcalli/nvim-colorizer.lua",
      disable = not plugin_status.nvim_colorizer,
      event = "BufRead",
      config = function()
         require("plugins.others").colorizer()
      end,
   }

   use {
      "plasticboy/vim-markdown",
      after = "packer.nvim",
      setup = function()
         require("plugins.others").markdown()
      end,
      ft = { "markdown" },
   }

   use {
      "dkarter/bullets.vim",
      after = "vim-markdown",
      ft = { "markdown", "text" },
      config = function()
         require("plugins.others").bullets()
      end,
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
      "kyazdani42/nvim-web-devicons",
      after = "packer.nvim",
      setup = function() 
         require "plugins/statusline"
      end,
   }

   use {
      "nvim-lua/plenary.nvim",
      after = "packer.nvim",
   }

   -- Theme
   use {
      "arcticicestudio/nord-vim",
      config = function()
         require "plugins.theme"
      end,
   }

   use {
      "nvim-telescope/telescope.nvim",
      after = "plenary.nvim",
      requires = {
         {
            "nvim-telescope/telescope-fzf-native.nvim",
            run = "make",
         },
      },
      config = function()
         require "plugins.telescope"
      end,
      setup = function()
         require("mappings").telescope()
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
      "andymass/vim-matchup",
      disable = not plugin_status.vim_matchup,
      event = "CursorMoved",
   }

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
