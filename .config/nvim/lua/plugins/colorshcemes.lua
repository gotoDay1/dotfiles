return {
    { "savq/melange-nvim",
        event = "UIEnter",
    },
    {
        "Mofiqul/dracula.nvim",
        event = "UIEnter",
        -- config = function()
        --     require("dracula").setup({
        --         transparent_bg = true, })
        -- end,
    },
    {
        "rebelot/kanagawa.nvim",
        event = "UIEnter",
        config = function()
            require("kanagawa").setup({
                transparent = true,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        event = "UIEnter",
        -- config = function()
        --     require("tokyonight").setup({
        --         style = "night",
        --         transparent = true,
        --     })
        -- end,
    },
    {
        "projekt0n/github-nvim-theme",
        event = "UIEnter",
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        event = "UIEnter",
        config = function()
            require("catppuccin").setup({
                transparent_background = true,
            })
            vim.cmd("colorscheme catppuccin-frappe")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        event = "UIEnter",
        -- config = function()
        --     require("gruvbox").setup({
        --         transparent_mode = true,
        --     })
        --     vim.cmd("colorscheme gruvbox")
        -- end,
    },
}
