return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "UIEnter",
        opts = {},
        config = function()
            local highlight = {
                "Whitespace",
            }
            require("ibl").setup {
                indent = { highlight = highlight, char = "▏" },
                whitespace = {
                    highlight = highlight,
                    remove_blankline_trail = false,
                },
                scope = { enabled = false },
            }
        end,
    }
}
