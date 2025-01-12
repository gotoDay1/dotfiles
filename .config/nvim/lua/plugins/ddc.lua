return {
    {
        "vim-denops/denops.vim",
        lazy = false,
        priority = 100,
        config = function()
            local home = os.getenv("HOME")
            vim.g["denops#deno"] = home .. "/.deno/bin/deno"
        end
    }, {
        "Shougo/pum.vim",
        lazy = false,
        priority = 10,
        config = function()
            vim.cmd([[
                inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
                inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
                inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
                inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
                inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
                inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
            ]])
        end
    }, {
        "Shougo/ddc.vim",
        event = "InsertEnter",
        dependencies = {
            "Shougo/ddc-source-around", "Shougo/ddc-ui-pum",
            "Shougo/ddc-matcher_head", "tani/ddc-fuzzy",
            "Shougo/ddc-sorter_rank", "Shougo/ddc-source-lsp",
            "uga-rosa/ddc-source-lsp-setup"
        },
        config = function()
            require("ddc_source_lsp_setup").setup()
            local capabilities =
                require("ddc_source_lsp").make_client_capabilities()
            require("lspconfig").denols.setup({capabilities = capabilities})

            -- Lua版のddc設定
            vim.fn['ddc#custom#patch_global']({
                ui = "pum",
                sources = {"lsp", "around", "skkeleton"},
                sourceOptions = {
                    ["_"] = {
                        matchers = {"matcher_fuzzy"},
                        sorters = {"sorter_fuzzy", "sorter_rank"},
                        converters = {"converter_fuzzy"}
                    },
                    ["around"] = {mark = "A"},
                    ["lsp"] = {
                        dup = "keep",
                        keywordPattern = [[\k+]],
                        sorters = {"sorter_lsp-kind"},
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
                        snippetEngine = vim.fn['denops#callback#register'](
                            function(body)
                                return vim.fn['vsnip#anonymous'](body)
                            end),
                        enableResolveItem = true,
                        enableAdditionalTextEdit = true,
                        confirmBehavior = 'replace'
                    }
                }
            })

            -- 補完のキーバインド設定（Enterキーで確定）
            vim.api.nvim_set_keymap("i", "<CR>",
                                    'pumvisible() ? ddc#accept() : "\\<C-g>u\\<CR>"',
                                    {noremap = true, silent = true, expr = true})

            -- DDCを有効化
            vim.fn['ddc#enable']()
        end
    }, -- MasonとLSPの設定
    {
        "williamboman/mason.nvim",
        event = "VeryLazy",
        config = function() require("mason").setup() end
    }, {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function()
            local mason = require("mason")
            local lspconfig = require("lspconfig")
            local mason_lspconfig = require("mason-lspconfig")
            mason.setup()
            mason_lspconfig.setup()
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({})
                end
            })
        end
    }, {
        "neovim/nvim-lspconfig",
        event = "VeryLazy"
    }, {
        "jose-elias-alvarez/null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.completion.spell
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_buf_set_option(bufnr, "formatexpr",
                                                    "v:lua.vim.lsp.formatexpr()")
                        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {
                            buffer = bufnr,
                            desc = "Format document"
                        })
                    end
                end
            })
        end
    }, {
        "jay-babu/mason-null-ls.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = {"black"}, -- blackをインストール
                handlers = {}
            })
        end
    }
}
