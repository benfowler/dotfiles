return {
    {
        -- Markdown support (better than stock)
        "preservim/vim-markdown",
        ft = "markdown",
        config = function()
            -- (required for sane bullet-list editing)
            vim.opt.comments = "b:>"
            vim.opt.formatoptions = "jtcqlnr"

            vim.g.vim_markdown_auto_insert_bullets = 0
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_math = 1
            vim.g.vim_markdown_new_list_item_indent = 2
            vim.g.vim_markdown_strikethrough = 1
        end,
    },

    {
        -- Cross-platform in-browser Markdown preview
        "davidgranstrom/nvim-markdown-preview",
        ft = "markdown",
        keys = {
            { "<leader>mm", ":MarkdownPreview<cr>", desc = "Preview" },
        },
        config = function()
            vim.g.nvim_markdown_preview_format = "gfm"
            vim.g.nvim_markdown_preview_theme = "solarized-dark"
        end,
    },

    {
        -- Sane bullet handling in Markdown etc
        "dkarter/bullets.vim",
        lazy = false,
        init = function()
            vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
            vim.g.bullets_checkbox_partials_toggle = 0
            vim.g.bullets_checkbox_markers = "   X"
        end,
    },
}
