local ok, indent = pcall(require, "indent_blankline")

if not ok then
    return
end

indent.setup {
    char = "│",
    space_char_blankline = " ",
    show_first_indent_level = false,
    show_trailing_blankline_indent = false,
    filetype_exclude = {
        "startify",
        "dashboard",
        "dotooagenda",
        "log",
        "fugitive",
        "gitcommit",
        "packer",
        "vimwiki",
        "markdown",
        "txt",
        "vista",
        "help",
        "todoist",
        "NvimTree",
        "peekaboo",
        "git",
        "TelescopePrompt",
        "undotree",
        "flutterToolsOutline",
        "", -- for all buffers without a file type
    },
    buftype_exclude = { "terminal", "nofile" },
    show_current_context = true,
    context_patterns = {
        "class",
        "function",
        "method",
        "block",
        "list_literal",
        "selector",
        "^if",
        "^table",
        "if_statement",
        "while",
        "for",
    },
}
