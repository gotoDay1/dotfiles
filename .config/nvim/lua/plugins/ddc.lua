return {
    {
        "vim-denops/denops.vim",
        lazy = false,
        priority = 100,
        config = function()
            local home = os.getenv("HOME")
            vim.g["denops#deno"] = home .. "/.deno/bin/deno"
        end,
    },
    {
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
        end,
    },
    {
        "Shougo/ddc.vim",
        event = "InsertEnter",
        dependencies = {
            "Shougo/ddc-source-around",
            "Shougo/ddc-ui-pum",
            "Shougo/ddc-matcher_head",
            "tani/ddc-fuzzy",
            "Shougo/ddc-sorter_rank",
            "Shougo/ddc-nvim-lsp",
            "Shougo/ddc-source-lsp",
        },
        config = function()
            local capabilities = require("ddc_source_lsp").make_client_capabilities()
            require("lspconfig").denols.setup({
              capabilities = capabilities,
            })
            vim.cmd([[
                " DDCのUIを設定 (pumを使う)
                call ddc#custom#patch_global('ui', 'pum')

                " 使用する補完ソースの設定
                call ddc#custom#patch_global('sources', ["nvim-lsp", 'around'])

                " 使用するフィルターの設定
                call ddc#custom#patch_global('sourceOptions', {
                    \ '_': {
                    \   'matchers': ['matcher_head', 'matcher_fuzzy'],
                    \   "sorters": ["sorter_fuzzy", "sorter_rank"],
                    \   "converters": ["converter_fuzzy"],
                    \ },
                    \ 'around': {
                    \   'mark': 'A',
                    \ },
                    \ "nvim-lsp": {
                    \ "mark": "LSP",
                    \ "forceCompletionPattern": '\.\w*|:\w*|->\w*'
                    \ },
                \ })

                " 補完のキーバインド設定（Enterキーで確定）
                inoremap <silent><expr> <CR> pumvisible() ? ddc#accept() : "\<C-g>u\<CR>"

                " DDCを有効化
                call ddc#enable()
            ]])
        end,
    },
    -- MasonとLSPの設定
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    { "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "fortls",
                    "pylsp",
                }
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = "BufEnter",
        config = function()
            local lspconfig = require('lspconfig')
            local capabilities = require('ddc_nvim_lsp').make_client_capabilities()
            local mason_lspconfig = require('mason-lspconfig')

            -- LSPサーバーの自動設定
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },
}
