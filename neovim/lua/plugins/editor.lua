local maps = require "config.keymaps"

return {
    {
        -- Pairs of handy bracket mappings
        "tpope/vim-unimpaired",
        event = "BufRead",
    },
    {
        -- Enable repeating supported plugins (like vim-unimpaired)
        "tpope/vim-repeat",
        event = "BufRead",
    },
    {
        -- Delete buffers without changing window layout
        "famiu/bufdelete.nvim",
        event = "BufRead",
    },
    {
        -- Camel- and snake-case motions
        "chaoren/vim-wordmotion",
        event = "BufRead",
    },
    {
        -- EasyMotion-like navigation
        "phaazon/hop.nvim",
        keys = {
            {
                maps.hop.easymotion_word_ac,
                function()
                    require("hop").hint_words {
                        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
                    }
                end,
                mode = { "n", "v", "o" },
                desc = "Hop word forward",
            },
            {
                maps.hop.easymotion_word_bc,
                function()
                    require("hop").hint_words {
                        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
                    }
                end,
                mode = { "n", "v", "o" },
                desc = "Hop word backward",
            },
            {
                maps.hop.easymotion_line_ac,
                function()
                    require("hop").hint_lines {
                        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
                    }
                end,
                mode = { "n", "v", "o" },
                desc = "Hop line down",
            },
            {
                maps.hop.easymotion_line_bc,
                function()
                    require("hop").hint_lines {
                        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
                    }
                end,
                mode = { "n", "v", "o" },
                desc = "Hop line up",
            },
            {
                maps.hop.sneak_char_ac,
                function()
                    require("hop").hint_char1 {
                        direction = require("hop.hint").HintDirection.AFTER_CURSOR,
                    }
                end,
                mode = { "n", "o" },
                desc = "Sneak forward",
            },
            {
                maps.hop.sneak_char_bc,
                function()
                    require("hop").hint_char1 {
                        direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
                    }
                end,
                mode = { "n", "o" },
                desc = "Sneak backward",
            },
        },
        opts = {},
    },
    {
        -- powerful surround functionality
        "kylechui/nvim-surround",
        version = "*", -- use for stability; omit to use `main` branch for the latest features
        event = "BufRead",
        config = function()
            require("nvim-surround").setup {
                -- configuration here, or leave empty to use defaults
            }
        end,
    },
    {
        -- Format tables etc
        "junegunn/vim-easy-align",
        cmd = { "EasyAlign", "LiveEasyAlign" },
        keys = {
            { maps.easy_align.easy_align, "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
        },
    },
}
