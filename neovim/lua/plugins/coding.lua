local maps = require "config.keymaps"

return {
    {
        -- Easy code commenting
        "terrortylor/nvim-comment",
        cmd = "CommentToggle",
        config = function()
            require("nvim_comment").setup()
        end,
        keys = {
            { maps.comment_nvim.comment_toggle, ":CommentToggle<CR>", mode = { "n", "v" }, desc = "(Un)comment" },
        },
    },
    {
        -- Pair completion
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            -- Don't add pairs if the next char is alphanumeric
            ignored_next_char = "[%w%.%$]", -- will ignore alphanumeric, `$` and `.` symbol

            -- Enable the very nice 'fast wrap' feature.  Activate with <M>-e.
            fast_wrap = {},
            highlight = "Search",
            highlight_grey = "Comment",

            -- Don't add pairs if it already has a close pair in the same line
            enable_check_bracket_line = true,
        },
    },
    {
        -- Make CSS colours stand out in files
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            "*",
            css = { css = true },
            html = { css = true },
        },
    },
}
