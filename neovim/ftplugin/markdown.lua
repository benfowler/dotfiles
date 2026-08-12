-- Pmenu max height
vim.opt.pumheight = 7

vim.opt.colorcolumn = '81'
vim.opt.conceallevel = 2
vim.opt.textwidth = 80

-- Spelling corrections from dict in omnicomplete by default
vim.opt.complete:append('k')
vim.opt.dictionary:append('/usr/share/dict/words')

vim.opt.spell = true

-- vim-markdown is lazy-loaded on FileType, so its ftplugin fires AFTER ours
-- and overrides gx with a syntax-based opener that breaks under Treesitter
-- (synID() returns nothing, so it always reports "not on a link").
-- Defer our mapping via vim.schedule() so it runs after vim-markdown has
-- loaded, restoring Neovim's Treesitter-aware vim.ui._get_urls() path.
local bufnr = vim.api.nvim_get_current_buf()
vim.schedule(function()
    vim.keymap.set('n', 'gx', function()
        -- Force a full parse so injected language trees (markdown_inline) are
        -- available; vim.ui._get_urls() needs those to find the url metadata.
        local parser = vim.treesitter.get_parser(bufnr)
        if parser then
            parser:parse(true)
        end
        for _, url in ipairs(vim.ui._get_urls()) do
            local cmd, err = vim.ui.open(url)
            local rv = cmd and cmd:wait(1000) or nil
            if cmd and rv and rv.code ~= 0 then
                err = ('vim.ui.open: command %s (%d): %s'):format(
                    (rv.code == 124 and 'timeout' or 'failed'),
                    rv.code,
                    vim.inspect(cmd.cmd)
                )
            end
            if err then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end
    end, { buffer = bufnr, desc = 'Opens filepath or URI under cursor with the system handler' })
end)
