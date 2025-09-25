local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath }
    vim.fn.system { "git", "-C", lazypath, "checkout", "tags/stable" } -- last stable release
end
vim.opt.rtp:prepend(lazypath)

return function(opts)
    opts = vim.tbl_deep_extend("force", {
        spec = {
            { import = "plugins" },
        },
        defaults = { lazy = true },
        install = {
            missing = true,
            colorscheme = { "onedark" },
        },
        checker = {
            enabled = true,
            frequency = 86400, -- once a day
        },
        diff = {
            cmd = "terminal_git",
        },
        performance = {
            cache = {
                enabled = true,
                -- disable_events = {},
            },
            rtp = {
                disabled_plugins = {
                    "gzip",
                    "rplugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                },
            },
        },
        debug = false,
    }, opts or {})
    require("lazy").setup(opts)
end
