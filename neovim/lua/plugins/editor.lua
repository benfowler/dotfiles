local maps = require "config.keymaps"

return {

    -- Delete buffers without changing window layout
    {
        "famiu/bufdelete.nvim",
        event = "BufRead",
    },

    -- Camel- and snake-case motions
    {
        "chaoren/vim-wordmotion",
        event = "BufRead",
    },

    -- powerful surround functionality
    {
        "kylechui/nvim-surround",
        version = "*", -- use for stability; omit to use `main` branch for the latest features
        event = "BufRead",
        config = function()
            require("nvim-surround").setup {
                -- configuration here, or leave empty to use defaults.  Plugin won't work without this.
            }
        end,
    },

    -- better quickfix buffer
    {
        "kevinhwang91/nvim-bqf",
        ft = 'qf'
    },

    -- Format tables etc
    {
        "junegunn/vim-easy-align",
        cmd = { "EasyAlign", "LiveEasyAlign" },
        keys = {
            { maps.easy_align.easy_align, "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
        },
    },
}
