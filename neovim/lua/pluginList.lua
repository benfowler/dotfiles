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

   -- Theme
   use {
      "arcticicestudio/nord-vim",
      config = function()
         require "plugins/nord"
      end
   }
end)
