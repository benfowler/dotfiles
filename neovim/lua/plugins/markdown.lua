return {
    {
        -- Markdown support (better than stock)
        'preservim/vim-markdown',
        ft = 'markdown',
        config = function()
            -- (required for sane bullet-list editing)
            vim.opt.comments = 'b:>'
            vim.opt.formatoptions = 'jtcqlnr'

            vim.g.vim_markdown_auto_insert_bullets = 0
            vim.g.vim_markdown_new_list_item_indent = 0
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_follow_anchor = 1
            vim.g.vim_markdown_math = 1
            vim.g.vim_markdown_strikethrough = 1
        end,
    },

    {
        -- Cross-platform in-browser Markdown preview
        'davidgranstrom/nvim-markdown-preview',
        ft = 'markdown',
        keys = {
            { '<leader>mm', ':MarkdownPreview<cr>', desc = 'Preview' },
            { '<leader>mh', ':Telescope heading theme=dropdown<cr>', desc = 'MD Headings' },
        },
        config = function()
            vim.g.nvim_markdown_preview_format = 'gfm'
            vim.g.nvim_markdown_preview_theme = 'solarized-dark'
        end,
    },

    {
        -- Sane bullet handling in Markdown etc
        'bullets-vim/bullets.nvim',
        lazy = false,
        ---@type bullets.Config
        opts = {
            enable_roman_list = false,

            -- BUGFIX:
            --
            -- Repeat 'std-' across levels: keeps the '-' marker stable across promote/demote
            -- while still giving auto_indent_after_colon a "next level" to indent into
            -- (a single-entry list leaves no next level, silently disabling that feature).

            outline_levels = { 'std-', 'std-', 'std-', 'std-', 'std-', 'std-', 'std-', 'std-' },
            auto_indent_after_colon = true,
        },
    },
}
