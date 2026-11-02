local maps = require('config.keymaps')

-- Prefer Copilot CLI, then Claude, then Codex.
local function pick_adapters()
    if vim.fn.executable('copilot') == 1 then
        return { chat = 'copilot_acp', inline = 'copilot_acp' }
    end
    if vim.env.ANTHROPIC_API_KEY then
        return { chat = 'anthropic', inline = 'anthropic' }
    end
    if vim.fn.executable('claude') == 1 then
        return { chat = { name = 'claude_code', type = 'acp' }, inline = vim.env.OPENAI_API_KEY and 'openai' or nil }
    end
    if vim.fn.executable('codex') == 1 then
        return { chat = { name = 'codex', type = 'acp' }, inline = vim.env.OPENAI_API_KEY and 'openai' or nil }
    end
    return {}
end

return {

    -- Core Copilot integration
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        ---@type CopilotConfig
        opts = {
            -- Disable native ghost text UI modules to prevent overlapping renders
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                ['*'] = true,
                -- Disable Copilot in certain filetypes
                ['TelescopePrompt'] = false,
                ['NvimTree'] = false,
                ['markdown'] = false,
                ['text'] = false,
            },
        },
    },

    -- Inline prompts and chat (Copilot, Claude or Codex)
    {
        'olimorris/codecompanion.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
        keys = {
            { maps.ai.inline, ':CodeCompanion ', mode = { 'n', 'v' }, desc = 'AI: inline prompt' },
            { maps.ai.actions, '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = 'AI: actions' },
            { maps.ai.chat, '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = 'AI: chat' },
        },
        config = function()
            local adapters = pick_adapters()
            require('codecompanion').setup({
                interactions = {
                    chat = { adapter = adapters.chat },
                    inline = { adapter = adapters.inline },
                },
            })
        end,
    },
}
