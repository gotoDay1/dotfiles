return {
    {
        "akinsho/toggleterm.nvim",
        event = "UIEnter",
        version = "*",
        config = function()
            require('toggleterm').setup({
                direction = "float",
                open_mapping = [[<c-t>]],
                close_on_exit = true
            })

            local Terminal = require("toggleterm.terminal").Terminal

            -- lazygit
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true
            })

            function _lazygit_toggle() lazygit:toggle() end

            vim.api.nvim_set_keymap("n", "<LEADER>lg",
                                    "<cmd>lua _lazygit_toggle()<CR>",
                                    {noremap = true, silent = true})

            -- lazydocker
            local lazydocker = Terminal:new({
                cmd = "lazydocker",
                direction = "float",
                hidden = true
            })

            function _lazydocker_toggle() lazydocker:toggle() end

            vim.api.nvim_set_keymap("n", "<LEADER>ld",
                                    "<cmd>lua _lazydocker_toggle()<CR>",
                                    {noremap = true, silent = true})

            -- aider 
            local aider = Terminal:new({
                cmd = "aider",
                direction = "float",
                hidden = true
            })

            function _aider_toggle() aider:toggle() end

            vim.api.nvim_set_keymap("n", "<LEADER>ai",
                                    "<cmd>lua _aider_toggle()<CR>",
                                    {noremap = true, silent = true})

            -- claude
            local claude = Terminal:new({
                cmd = "claude",
                direction = "float",
                hidden = true
            })

            function _claude_toggle() claude:toggle() end

            vim.api.nvim_set_keymap("n", "<LEADER>cl",
                                    "<cmd>lua _claude_toggle()<CR>",
                                    {noremap = true, silent = true})
        end
    }
}
