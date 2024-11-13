return {
    -- Denopsは他のプラグインより先に読み込む必要があります
    {
        "vim-denops/denops.vim",
        lazy = false,
        priority = 1000,
    },
    -- pum.vimはポップアップメニューを提供します
    {
        "Shougo/pum.vim",
        lazy = false,
    },
    -- lsp
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },
    -- ddc.vimと関連プラグイン
    {
        "Shougo/ddc.vim",
        dependencies = {
            "Shougo/ddc-ui-pum",
            "Shougo/ddc-source-around",
            "Shougo/ddc-source-lsp",
            "uga-rosa/ddc-source-lsp-setup",
            "Shougo/ddc-filter-matcher_head",
            "Shougo/ddc-filter-sorter_rank",
            "hrsh7th/vim-vsnip",                   -- スニペットエンジン
        },
        event = {"InsertEnter"},
        config = function()
            -- LSPサーバーの設定
            local lspconfig = require("lspconfig")
            local capabilities = vim.fn["ddc#lsp#make_client_capabilities"]()

            -- 例としてdenolsを設定（他のサーバーも同様に設定可能）
            lspconfig.denols.setup({
                capabilities = capabilities,
            })
            -- fortran
            lspconfig.intelephense.setup({
                capabilities = capabilities,
            })

            -- DDCのグローバル設定
            local patch_global = vim.fn["ddc#custom#patch_global"]

            -- ソースの設定（'lsp'を追加）
            patch_global("sources", {"lsp", "around"})

            -- ソースオプションの設定
            patch_global("sourceOptions", {
                ["_"] = {
                    matchers = {"matcher_head"},
                    sorters = {"sorter_rank"},
                },
                ["lsp"] = {
                    mark = "lsp",
                    forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*',
                },
            })

            -- ソースパラメータの設定
            patch_global("sourceParams", {
                ["lsp"] = {
                    snippetEngine = vim.fn["denops#callback#register"](function(body)
                        return vim.fn["vsnip#anonymous"](body)
                    end),
                    enableResolveItem = true,
                    enableAdditionalTextEdit = true,
                },
            })

            -- その他の設定
            patch_global({
                ui = "pum",
                autoCompleteEvents = {"InsertEnter", "TextChangedI", "TextChangedP"},
            })

            -- DDCを有効化
            vim.fn["ddc#enable"]()

            -- キーマッピングの設定（Ctrl-n と Ctrl-p を使用）
            vim.api.nvim_set_keymap("i", "<C-n>", "<Cmd>call pum#map#insert_relative(+1)<CR>", {noremap = true, silent = true})
            vim.api.nvim_set_keymap("i", "<C-p>", "<Cmd>call pum#map#insert_relative(-1)<CR>", {noremap = true, silent = true})
            vim.api.nvim_set_keymap("i", "<expr><CR>", 'pum#map#confirm()', {expr = true, noremap = true})
        end,
    },
}

