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
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true
            })

            function _lazygit_toggle() lazygit:toggle() end

            vim.api.nvim_set_keymap("n", "<LEADER>lg",
                                    "<cmd>lua _lazygit_toggle()<CR>",
                                    {noremap = true, silent = true})
        end
    }
}
