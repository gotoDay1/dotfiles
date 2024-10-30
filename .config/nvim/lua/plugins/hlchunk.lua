return{
    {
        "shellRaining/hlchunk.nvim",
        event = { "VimEnter" },
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
                    enable = true,
                    chars = {
                                "│",
                                "¦",
                                "┆",
                                "┊",
                            },
                    style = {
                                vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
                            },
                },
                
                line_num = {
                    enable = true,
                },

            })
        end
    }
}

