return {
    {
        'stevearc/conform.nvim',
        event = { "BufWritePre" }, -- 保存時に実行するためにイベントを指定
        cmd = { "ConformInfo" },   -- :ConformInfo でデバッグ可能
        opts = {
            -- 1. 言語ごとのフォーマッタ指定
            formatters_by_ft = {
                lua = { "stylua" },
                -- 複数の場合は順番に試行。["prettierd", "prettier", stop_after_first = true]
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                python = { "ruff" }, -- pythonは両方実行
                rust = { "rustfmt" },
                -- どのfiletypeにも当てはまらない場合
                ["_"] = { "trim_whitespace" },
            },

            -- 2. 保存時の自動フォーマット設定
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true, -- フォーマッタがない場合はLSPのフォーマットを使う
            },

            -- 3. フォーマッタの個別設定（必要に応じて）
            formatters = {
                sh = {
                    command = "shfmt",
                    prepend_args = { "-i", "2" }, -- インデント幅の指定など
                },
            },
        },
        -- キーマップの設定（手動でフォーマットしたい場合）
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
    },
}
