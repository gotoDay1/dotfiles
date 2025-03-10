return {
    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"
        },
        opts = {
            language = "japanese",
            adapter = {
                openai = function()
                    local home = vim.fn.expand("$HOME")
                    local gkgpye = vim.fn.expand("$GKGPYE")
                    return require("codecompanion.adapters").extend("openai", {
                        env = {
                            api_key = 'cmd:gpg --batch --quiet --decrypt --passphrase ' .. gkgpye .. ' ' ..
                                home .. '/.openai.txt.gpg'
                        },
                        schema = {model = {default = 'o3-mini'}}
                    })
                end
            },
            strategies = {
                chat = {adapter = "openai"},
                inline = {adapter = "openai"},
            }
        }
    }
}
