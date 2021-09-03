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

    -- Plugins for editing prose
    use {
        "plasticboy/vim-markdown",
        after = "packer.nvim",
        ft = { "markdown" },
        setup = function()
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

    -- Snippets
    use {
        "SirVer/ultisnips",
        disable = not plugin_status.ultisnips,
        event = "InsertEnter",
        config = function()
            require("plugins.others").ultisnips()
        end,
        setup = function()
            require("mappings").ultisnips()
        end,
    }

    use {
        "honza/vim-snippets",
        after = "ultisnips",
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

    -- Load custom statusline (no plugin)
    use {
        "kyazdani42/nvim-web-devicons",
        after = "nord-vim",
        setup = function()
            require "plugins/statusline"
        end,
    }

    -- Theme
    use {
        "arcticicestudio/nord-vim",
        config = function()
            require "plugins.theme"
        end,
    }

    -- Telescope: powerful fuzzy finder for Neovim
    use {
        "nvim-lua/plenary.nvim",
        after = "packer.nvim",
    }

    use {
        "nvim-telescope/telescope.nvim",
        after = { "plenary.nvim" },
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            { "crispgm/telescope-heading.nvim" },
            { "fhill2/telescope-ultisnips.nvim" },
        },
        config = function()
            require "plugins.telescope"
            require("mappings").telescope()
        end,
    }

    use {
        "nvim-telescope/telescope-frecency.nvim",
        after = { "telescope.nvim" },
        requires = { "tami5/sql.nvim" },
        config = function()
            require("telescope").load_extension "frecency"
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
