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
        "qpkorr/vim-bufkill", -- 'BD' to kill a buffer without closing a split
        after = "packer.nvim",
        cmd = { "BUN", "BD", "BW", "BB", "BF", "BA" },
    }

    use {
        "junegunn/vim-easy-align",
        after = "packer.nvim",
        cmd = { "EasyAlign", "EasyAlign!", "LiveEasyAlign" },
        setup = function()
            require("mappings").easy_align()
        end,
    }

    use {
        "tpope/vim-surround",
        event = "InsertEnter",
    }

    use {
        "mattn/emmet-vim",
        event = "InsertEnter",
    }

    use {
        "norcalli/nvim-colorizer.lua",
        disable = not plugin_status.nvim_colorizer,
        event = "BufRead",
        config = function()
            require("plugins.others").colorizer()
        end,
    }

    -- Theme
    use {
        "arcticicestudio/nord-vim",
        config = function()
            require "plugins.theme"
        end,
    }

    -- Eagerly loaded (needed at startup by nvim-tree)
    use {
        "kyazdani42/nvim-web-devicons",
    }

    -- Load custom statusline (local plugin).  Eagerly loaded.
    use {
        "~/.nvim-lua/nvim/local-plugins/statusline",
        config = function()
            require("plugins.others").statusline()
        end,
    }

    -- LSP stuff
    use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        config = function()
            require "plugins.treesitter"
        end,
    }

    use {
        "kosayoda/nvim-lightbulb",
        event = "BufRead",
        config = function()
            require("plugins.others").lightbulb()
        end,
    }

    use {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    }

    use {
        "kabouzeid/nvim-lspinstall",
        event = "BufRead",
    }

    use {
        "neovim/nvim-lspconfig",
        after = "nvim-lspinstall",
        requires = { "nvim-lua/lsp-status.nvim" },
        config = function()
            require "plugins.lspconfig"
        end,
    }

    use {
        "ray-x/lsp_signature.nvim",
        disable = not plugin_status.lspsignature,
        after = "nvim-lspconfig",
        config = function()
            require("plugins.others").signature()
        end,
    }

    -- Plugins for editing prose
    use {
        "plasticboy/vim-markdown",
        ft = { "markdown" },
        config = function()
            require("plugins.others").markdown()
        end,
    }

    use {
        "dkarter/bullets.vim",
        after = "vim-markdown",
        ft = { "markdown", "text" },
        config = function()
            require("plugins.others").bullets()
        end,
    }

    -- Autocomplete support
    use {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
    }

    use {
        "hrsh7th/nvim-cmp",
        after = "friendly-snippets",
        config = function()
            require "plugins.cmp"
        end,
    }

    use {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
        config = function()
            require("plugins.others").luasnip()
            require("mappings").luasnip()
        end,
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    }

    use {
        "hrsh7th/cmp-nvim-lua",
        after = "cmp_luasnip",
    }

    use {
        "hrsh7th/cmp-nvim-lsp",
        after = "cmp-nvim-lua",
    }

    use {
        "hrsh7th/cmp-buffer",
        after = "cmp-nvim-lsp",
    }

    -- tmux integration
    use {
        "christoomey/vim-tmux-navigator",
        disable = not plugin_status.vim_tmux_navigator,
        cmd = {
            "TmuxNaviateLeft",
            "TmuxNavigateRight",
            "TmuxNavigateLeft",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        after = "packer.nvim",
        setup = function()
            require("mappings").vim_tmux_navigator()
        end,
    }

    -- File managmeent
    use {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require "plugins.nvimtree"
        end,
        setup = function()
            require("mappings").nvimtree()
        end,
    }

    use {
        "nvim-lua/plenary.nvim",
        after = "packer.nvim",
    }

    use {
        "nvim-telescope/telescope.nvim",
        after = { "plenary.nvim" },
        requires = {
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            { "crispgm/telescope-heading.nvim" },
        },
        config = function()
            require "plugins.telescope"
            require("mappings").telescope()
        end,
    }

    use {
        "junegunn/fzf.vim",
        requires = { "junegunn/fzf" },
        config = function()
            require "plugins.fzf"
        end,
        setup = function()
            require("mappings").fzf()
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
        cmd = { "Git", "Gread", "Gwrite", "Gdiff" }, -- add any other Fugitive commands to lazy-load on
        setup = function()
            require("mappings").fugitive()
        end,
    }

    -- Misc plugins
    use {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require("plugins.others").autopairs()
        end,
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
        "rafcamlet/nvim-luapad",
        cmd = { "Luapad", "LuaRun" },
    }

    use {
        "Pocco81/TrueZen.nvim",
        disable = not plugin_status.truezen_nvim,
        cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
        setup = function()
            require "plugins.zenmode"
            require("mappings").truezen()
        end,
    }
end)
