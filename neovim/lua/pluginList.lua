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

   -- Theme
   use {
      "arcticicestudio/nord-vim",
      config = function()
         require "plugins/nord"
      end
   }
end)
