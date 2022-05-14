local M = { }

M.config = function()
    local has_autopairs, autopairs = pcall(require, "nvim-autopairs")

    local has_autopairs_cmp, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    local cmp = require('cmp')

    if not (has_autopairs or has_autopairs_cmp) then
        return
    end

    -- nvim-cmp integration
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

    autopairs.setup({
      -- Don't add pairs if the next char is alphanumeric
      ignored_next_char = "[%w%.%$]",   -- will ignore alphanumeric, `$` and `.` symbol

      -- Enable the very nice 'fast wrap' feature.  Activate with <M>-e.
      fast_wrap = {},
      highlight = 'Search',
      highlight_grey = 'Comment',

      -- Don't add pairs if it already has a close pair in the same line
      enable_check_bracket_line = false,
    })
end

return M
