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
        -- EasyMotion-like navigation
        "phaazon/hop.nvim",
        keys = {
            { maps.hop.easymotion_word_ac, ":HopWordAC<CR>", mode = { "n", "v" }, desc = "Hop word forward" },
            { maps.hop.easymotion_word_bc, ":HopWordBC<CR>", mode = { "n", "v" }, desc = "Hop word backward" },
            { maps.hop.easymotion_line_ac, ":HopLineAC<CR>", mode = { "n", "v" }, desc = "Hop line down" },
            { maps.hop.easymotion_line_bc, ":HopLineBC<CR>", mode = { "n", "v" }, desc = "Hop line up" },
            { maps.hop.sneak_char_ac, ":HopChar2AC<CR>", mode = { "n", "v" }, desc = "Sneak char forward" },
            { maps.hop.sneak_char_bc, ":HopChar2BC<CR>", mode = { "n", "v" }, desc = "Sneak char backward" },
        },
        opts = {},
    },
    {
        -- Powerful surround functionality
        "kylechui/nvim-surround",
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
