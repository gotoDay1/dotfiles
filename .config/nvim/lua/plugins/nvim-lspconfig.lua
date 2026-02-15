return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"saghen/blink.cmp",
	},
	-- バッファを開いた時にロードする設定（遅延ロード）
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- 1. 使用するサーバーのリスト
		local servers = { "rust_analyzer", "ruff", "pyright", "lua_ls" }
		local capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		for _, server in ipairs(servers) do
			vim.lsp.config(server, capabilities)
			vim.lsp.enable(server)
		end
		vim.diagnostic.config({
			virtual_text = true, -- 行の横にメッセージを表示
			signs = true, -- 行番号の横にアイコンを表示
			underline = true, -- エラー箇所に波線を表示
			update_in_insert = false, -- 入力中は更新しない（うるさくないように）
			severity_sort = true,
		})
	end,
}
