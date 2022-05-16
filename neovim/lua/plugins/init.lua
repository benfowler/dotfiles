local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    -- stylua: ignore
    PACKER_BOOTSTRAP = vim.fn.system {
        "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path,
    }
end
vim.cmd [[packadd packer.nvim]]

local packer_loaded, packer = pcall(require, "packer")

if not packer_loaded then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "single" }
        end,
        prompt_border = "single",
    },
    git = {
        clone_timeout = 600, -- Timeout, in seconds, for git clones
    },
    auto_clean = true,
    compile_on_sync = true,
    --    auto_reload_compiled = true
    log = { level = "warn" }, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
    profile = {
        enable = true,
        threshold = 1, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
    },
}

return packer.startup(function(use)
    use {
        "wbthomason/packer.nvim",
    }

    -- UI extension hooks
    use {
        "stevearc/dressing.nvim",
        config = function()
            require "plugins.config.dressing"
        end,
    }

    use {
        "rcarriga/nvim-notify",
        config = function()
            require "plugins.config.notify"
        end,
    }

    -- Editing features
    use {
        "qpkorr/vim-bufkill", -- 'BD' to kill a buffer without closing a split
    }

    use {
        "junegunn/vim-easy-align",
        cmd = { "EasyAlign", "EasyAlign!", "LiveEasyAlign" },
        keys = "<Plug>(EasyAlign)",
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
        event = "BufRead",
        config = function()
            require "plugins.config.colorizer"
        end,
    }

    -- Theme
    use {
        "rmehri01/onenord.nvim",
        config = function()
            require "plugins.config.theme"
        end,
    }

    -- Eagerly loaded (needed at startup by nvim-tree)
    use {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require "plugins.config.webdevicons"
        end,
    }

    -- LSP stuff
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = "windwp/nvim-ts-autotag",
        config = function()
            require "plugins.config.treesitter"
        end,
    }

    use {
        "kosayoda/nvim-lightbulb",
        event = "BufRead",
        config = function()
            require "plugins.config.lightbulb"
        end,
    }

    use {
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/nvim-lsp-installer",
            "nvim-lua/lsp-status.nvim"
        },
        config = function()
            require("nvim-lsp-installer").setup {}
            require "plugins.config.lspconfig"
        end,
    }

    use {
        "onsails/lspkind-nvim",
        config = function()
            require "plugins.config.lspkind"
        end,
    }

    use {
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        after = "lspkind-nvim",
        config = function()
            require "toggle_lsp_diagnostics"
        end,
    }

    use {
        "j-hui/fidget.nvim",
        after = "nvim-lspconfig",
        config = function()
            require "plugins.config.fidget"
        end,
    }

    use {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require "plugins.config.trouble"
        end,
        setup = function()
            require("mappings").trouble()
        end,
    }

    use {
        "jose-elias-alvarez/null-ls.nvim",
        requires = "nvim-lua/plenary.nvim",
    }

    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end,
    }

    -- Plugins for editing prose
    use {
        "plasticboy/vim-markdown",
        ft = { "markdown" },
        config = require "plugins.config.markdown",
    }

    use {
        "dkarter/bullets.vim",
        after = "vim-markdown",
        ft = { "markdown", "text" },
        config = require "plugins.config.bullets",
    }

    use {
        "lervag/vimtex",
        ft = "tex",
        config = require "plugins.config.vimtex",
    }

    -- Autocomplete support
    use {
        "L3MON4D3/LuaSnip",
        requires = "rafamadriz/friendly-snippets",
        config = function()
            require "plugins.config.luasnip"
        end,
    }

    use {
        "hrsh7th/nvim-cmp",
        after = "LuaSnip",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = function()
            require "plugins.config.cmp"
        end,
    }

    -- tmux integration
    use {
        "christoomey/vim-tmux-navigator",
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
            require "plugins.config.nvimtree"
        end,
        setup = function()
            require("mappings").nvimtree()
        end,
    }

    -- TODO: Telescope isn't yet lazy-loaded, because lazy-loading it
    --       prevents LSP from initialising, and requires an LSP
    --       restart (:e) to launch.
    use {
        "nvim-telescope/telescope.nvim",
        after = "plenary.nvim",
        --cmd =  "Telescope" ,
        requires = {
            { "plenary.nvim" },
        },
        config = function()
            require "plugins.config.telescope"
        end,
    }

    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        module = "telescope._extensions.fzf",
    }

    use {
        "crispgm/telescope-heading.nvim",
        module = "telescope._extensions.heading",
    }

    use {
        "scalameta/nvim-metals",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        module = { "telescope._extensions.metals" },
    }

    -- WARNING: won't actually find any snippets until LuaSnip is loaded
    use {
        "benfowler/telescope-luasnip.nvim",
        module = { "telescope._extensions.luasnip" },
    }

    --stylua: ignore
    use {
        "junegunn/fzf",
        cmd = {
            "Files", "GFiles", "GFiles?", "Buffers", "Colors", "Ag", "Rg",
            "Lines", "BLines", "Tags", "BTags", "Marks", "Windows", "Locate",
            "History", "History", "History/", "Snippets", "Commits",
            "BCommits", "Commands", "Maps", "Helptags", "Filetypes"
        },
    }

    use {
        "junegunn/fzf.vim",
        after = "fzf",
        config = function()
            require "plugins.config.fzf"
        end,
    }

    -- Git support
    use {
        "lewis6991/gitsigns.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require "plugins.config.gitsigns"
        end,
    }

    use {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gread", "Gwrite", "Gdiff" },
        setup = function()
            require("mappings").fugitive()
        end,
    }

    -- Misc plugins
    use {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require "plugins.config.autopairs"
        end,
    }

    -- Commenting help
    use {
        "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        config = function()
            require("nvim_comment").setup()
        end,
        setup = function()
            require("mappings").comment_nvim()
        end,
    }

    use {
        "Pocco81/TrueZen.nvim",
        cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
        setup = function()
            require "plugins.config.zenmode"
            require("mappings").truezen()
        end,
    }

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
