-- VIM-MARKDOWN PLUGIN

return function()
    local opt = vim.opt
    local g = vim.g

    -- (required for sane bullet-list editing)
    opt.comments = "b:>"
    opt.formatoptions = "jtcqlnr"

    g.vim_markdown_new_list_item_indent = 2
    g.vim_markdown_auto_insert_bullets = 0
    g.vim_markdown_math = 1
end
