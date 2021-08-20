local cmd = vim.cmd

-- Make keybinding with optional options
local function map(mode, lhs, rhs, opts)
   local options = { noremap = true, silent = true }
   if opts then
      options = vim.tbl_extend("force", options, opts)
   end
   vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local M = {}
local opt = {}


-- these mappings will only be called during initialization
M.misc = function()

   -- Packer commands, because we are not loading it at startup
   cmd "silent! command PackerCompile lua require 'pluginList' require('packer').compile()"
   cmd "silent! command PackerInstall lua require 'pluginList' require('packer').install()"
   cmd "silent! command PackerStatus lua require 'pluginList' require('packer').status()"
   cmd "silent! command PackerSync lua require 'pluginList' require('packer').sync()"
   cmd "silent! command PackerUpdate lua require 'pluginList' require('packer').update()"
end

-- TODO: add mappings.


return M

