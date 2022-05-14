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

    -- UI extension hooks
    use {
        "stevearc/dressing.nvim",
        event = "VimEnter",
        config = function()
            require("plugins.config.others").dressing()
        end,
    }

    use {
        "rcarriga/nvim-notify",
        event = "VimEnter",
        config = function()
            require("plugins.config.others").notify()
        end,
    }

    -- Editing features
    use {
        "qpkorr/vim-bufkill", -- 'BD' to kill a buffer without closing a split
        event = "VimEnter",
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
            require("plugins.config.others").colorizer()
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
    }

    -- Load custom statusline (local plugin).  Eagerly loaded.
    use {
        "~/.config/nvim/local-plugins/statusline",
        config = function()
            require("plugins.config.others").statusline()
        end,
    }

    -- LSP stuff
    use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        config = function()
            require "plugins.config.treesitter"
        end,
    }

    use {
        "kosayoda/nvim-lightbulb",
        event = "BufRead",
        config = function()
            require("plugins.config.others").lightbulb()
        end,
    }

    use {
        -- required by lspconfig init to enumerate installed servers
        "williamboman/nvim-lsp-installer",
    }

    use {
        "neovim/nvim-lspconfig",
        after = "nvim-lsp-installer",
        requires = { "nvim-lua/lsp-status.nvim" },
        config = function()
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
            require 'toggle_lsp_diagnostics'.init()
        end,
    }

    use {
        "j-hui/fidget.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("plugins.config.others").fidget()
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
            -- Left empty to use the default settings
            require("todo-comments").setup()
        end,
    }

    -- Plugins for editing prose
    use {
        "plasticboy/vim-markdown",
        ft = { "markdown" },
        config = function()
            require("plugins.config.others").markdown()
        end,
    }

    use {
        "dkarter/bullets.vim",
        after = "vim-markdown",
        ft = { "markdown", "text" },
        config = function()
            require("plugins.config.others").bullets()
        end,
    }

    use {
        "lervag/vimtex",
        ft = "tex",
        config = function()
            require("plugins.config.others").vimtex()
        end,
    }

    -- Autocomplete support
    use {
        "rafamadriz/friendly-snippets",
        event = "InsertEnter",
    }

    use {
        "L3MON4D3/LuaSnip",
        after = "friendly-snippets",
        config = function()
            require("plugins.config.others").luasnip()
        end,
    }

    use {
        "hrsh7th/nvim-cmp",
        after = "LuaSnip",
        config = function()
            require "plugins.config.cmp"
        end,
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "nvim-cmp",
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
        "hrsh7th/cmp-nvim-lsp-signature-help",
        after = "cmp-nvim-lsp",
    }

    use {
        "hrsh7th/cmp-path",
        after = "cmp-nvim-lsp-signature-help",
    }

    use {
        "hrsh7th/cmp-buffer",
        after = "cmp-path",
    }

    use {
        "hrsh7th/cmp-cmdline",
        after = "cmp-buffer",
    }

    use {
        "kdheepak/cmp-latex-symbols",
        after = "cmp-cmdline",
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

    use {
        "nvim-lua/plenary.nvim",
        after = "packer.nvim",
    }

    use {
        "scalameta/nvim-metals",
        ft = { "scala", "sbt" },
        requires = {
            { "nvim-lua/plenary.nvim" },
        },
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

    -- WARNING: won't actually find any snippets until LuaSnip is loaded
    use {
        "benfowler/telescope-luasnip.nvim",
        module = { "telescope._extensions.luasnip" },
    }

    --stylua: ignore
    use {
        "junegunn/fzf",
        cmd = {
            "Files", "GFiles", "GFiles?", "Buffers", "Colors", "Ag", "Rg", "Lines", "BLines",
            "Tags", "BTags", "Marks", "Windows", "Locate", "History", "History", "History/",
            "Snippets", "Commits", "BCommits", "Commands", "Maps", "Helptags", "Filetypes"
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
        after = "plenary.nvim",
        config = function()
            require "plugins.config.gitsigns"
        end,
    }

    use {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gread", "Gwrite", "Gdiff" }, -- add any other Fugitive commands to lazy-load on
        setup = function()
            require("mappings").fugitive()
        end,
    }

    -- Misc plugins
    use {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
            require("plugins.config.others").autopairs()
        end,
    }

    -- Commenting help
    use {
        "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        config = function()
            require("plugins.config.others").comment()
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
        cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
        setup = function()
            require "plugins.config.zenmode"
            require("mappings").truezen()
        end,
    }
end)
