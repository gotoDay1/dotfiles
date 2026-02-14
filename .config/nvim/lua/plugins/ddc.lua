return {
    -- 1. Denops (ddc/skkeletonの基盤)
    {
        "vim-denops/denops.vim",
        lazy = false,
        priority = 100,
        config = function()
            local home = os.getenv("HOME")
            -- Denoのパス設定
            vim.g["denops#deno"] = home .. "/.deno/bin/deno"
        end
    },

    -- 2. Popup Window UI
    {
        "Shougo/pum.vim",
        lazy = false,
        config = function()
            vim.keymap.set("i", "<C-n>", "<Cmd>call pum#map#insert_relative(+1)<CR>")
            vim.keymap.set("i", "<C-p>", "<Cmd>call pum#map#insert_relative(-1)<CR>")
            vim.keymap.set("i", "<C-y>", "<Cmd>call pum#map#confirm()<CR>")
            vim.keymap.set("i", "<C-e>", "<Cmd>call pum#map#cancel()<CR>")
        end
    },

    -- 3. DDC.vim (補完本体)
    {
        "Shougo/ddc.vim",
        event = { "InsertEnter", "LspAttach" }, -- LSP起動時にもロード
        dependencies = {
            "vim-denops/denops.vim",
            "Shougo/ddc-ui-pum",
            "Shougo/ddc-source-lsp",
            "uga-rosa/ddc-source-lsp-setup",
            "Shougo/ddc-source-around",
            "Shougo/ddc-matcher_head",
            "tani/ddc-fuzzy",
            "Shougo/ddc-sorter_rank",
        },
        config = function()
            -- ddc-source-lsp-setup を先に実行
            require("ddc_source_lsp_setup").setup()

            vim.fn['ddc#custom#patch_global']({
                ui = "pum",
                sources = { "lsp", "around", "skkeleton" },
                sourceOptions = {
                    ["_"] = {
                        matchers = { "matcher_fuzzy" },
                        sorters = { "sorter_fuzzy", "sorter_rank" },
                        converters = { "converter_fuzzy" }
                    },
                    ["around"] = { mark = "A" },
                    ["lsp"] = {
                        dup = "keep",
                        keywordPattern = [[\k+]],
                        mark = "LSP",
                        forceCompletionPattern = [[\.\w*|:\w*|->\w*]]
                    },
                    ["skkeleton"] = {
                        mark = "SKK",
                        matchers = {},
                        sorters = {},
                        converters = {},
                        isVolatile = true,
                        minAutoCompleteLength = 1
                    }
                },
                sourceParams = {
                    ["lsp"] = {
                        -- Snippet設定 (vsnip使用を想定)
                        snippetEngine = vim.fn['denops#callback#register'](
                            function(body) return vim.fn['vsnip#anonymous'](body) end
                        ),
                        enableResolveItem = true,
                        enableAdditionalTextEdit = true,
                        confirmBehavior = 'replace'
                    }
                }
            })

            -- 補完決定時の改行制御
            vim.keymap.set("i", "<CR>", [[pumvisible() ? ddc#accept() : "\<C-g>u\<CR>"]], { expr = true, silent = true })

            vim.fn['ddc#enable']()
        end
    },

    -- 4. LSP Config & Mason
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "Shougo/ddc.vim", -- ロード順序を保証
        },
        config = function()
            local capabilities = require("ddc_source_lsp").make_client_capabilities()

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "rust_analyzer", "pyright", "denols" }
            })
        end
    },

    -- 5. None-ls (Python等のフォーマッタ用)
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "jay-babu/mason-null-ls.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                },
            })
            require("mason-null-ls").setup({
                ensure_installed = { "black" },
                automatic_installation = true,
            })
        end
    }
}
