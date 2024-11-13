return{
    {
        "williamboman/mason.nvim",
        lazy = false,
        dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        },
        config = function() -- Execute after plugin is loaded
            local mason = require('mason')
            mason.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
            local mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup()
        end,
    }
}

