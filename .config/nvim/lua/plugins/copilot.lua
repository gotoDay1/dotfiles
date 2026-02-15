return {
	{
		"github/copilot.vim",
		event = "VimEnter",
		init = function()
			-- 1. グローバル変数を 0 に設定（基本）
			vim.g.copilot_enabled = 0

			-- 2. (追加) ファイルを開いた時に自動で起動しないようにする設定
			-- これを指定しておかないと、ファイルタイプが決定した瞬間に有効になる場合があります
			vim.g.copilot_filetypes = { ["*"] = false }
		end,
	},
}
