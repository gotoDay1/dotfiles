return {
    {
        "savq/melange-nvim",
        event = "UIEnter",
    },
    {
        "Mofiqul/dracula.nvim",
        event = "UIEnter",
        -- config = function()
        --     require("dracula").setup({
        --         transparent_bg = true,
        --     })
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
    },
    {
        "ellisonleao/gruvbox.nvim",
        event = "UIEnter",
    },
}
