-- luacheck configuration for a Neovim Lua config
-- https://luacheck.readthedocs.io/en/stable/config.html

-- Paths to check (mirrors `mise run lint`)
files = { "lua/", "ftplugin/" }

-- Neovim's global `vim` table
globals = { "vim" }

-- Suppress warnings for unused function arguments (common in Neovim callbacks)
no_unused_args = true

-- Line length is enforced by StyLua; disable here to avoid false positives
-- inside intentional `-- stylua: ignore` regions.
max_line_length = false

-- 113: accessing undefined field of a global (too noisy with vim.* APIs)
-- 212: unused argument in functions with fixed signatures (e.g. callbacks)
ignore = { "113", "212" }

-- Globals set intentionally outside of the module pattern
globals = { "vim", "Statusline" }
