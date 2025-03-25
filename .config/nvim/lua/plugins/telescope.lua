return {
    {
        "nvim-telescope/telescope.nvim",
        event = "UIEnter",
        config = function() -- Execute after plugin is loaded
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        event = "UIEnter",
        config = function()
            require('telescope').setup({
                extensions = {
                    file_browser = {
                        hidden = true,
                        show_system = true,
                        auto_depth = true,
                        -- theme = "dropdown",
                        -- theme = "ivy",
                        -- theme = "cursor",
                    },
                },
            })
            require('telescope').load_extension('file_browser')
            vim.keymap.set('n', '<leader>fe', require('telescope').extensions.file_browser.file_browser, {})
        end,
    },
}
