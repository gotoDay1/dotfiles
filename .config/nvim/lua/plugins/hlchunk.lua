return{
    {
        "shellRaining/hlchunk.nvim",
        event = { "UIEnter" },
        config = function()
            require('hlchunk').setup({
                chunk = {
                    enable = true,
                    notify = true,
                    use_treesitter = true,
                    chars = {
                        horizontal_line = "─",
                        vertical_line = "│",
                        left_top = "╭",
                        left_bottom = "╰",
                        right_arrow = ">",
                    },
                },

                blank = {
                    enable = false,
                },

                indent = {
                    chars = { "│", "¦", "┆", "┊", }, -- more code can be found in https://unicodeplus.com/
                },

            })
        end
    }
}

