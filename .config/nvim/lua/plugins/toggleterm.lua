return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "UIEnter",
		-- 1. 基本設定は opts に書く
		opts = {
			direction = "float",
			open_mapping = [[<c-t>]],
			close_on_exit = true,
			float_opts = {
				border = "rounded",
			},
		},
		-- 2. キーマッピングとカスタムターミナルの定義
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local Terminal = require("toggleterm.terminal").Terminal

			-- 共通のトグル関数を作成するヘルパー
			local function create_toggle(cmd)
				local term = Terminal:new({
					cmd = cmd,
					direction = "float",
					hidden = true,
				})
				return function()
					term:toggle()
				end
			end

			-- 各ツールのトグル関数を生成
			local toggle_lazygit = create_toggle("lazygit")
			local toggle_lazydocker = create_toggle("lazydocker")
			local toggle_aider = create_toggle("aider")
			local toggle_claude = create_toggle("claude")

			-- キーマッピングの登録 (config内で行う)
			local map = vim.keymap.set
			map("n", "<leader>lg", toggle_lazygit, { desc = "LazyGit" })
			map("n", "<leader>ld", toggle_lazydocker, { desc = "LazyDocker" })
			map("n", "<leader>ai", toggle_aider, { desc = "Aider" })
			map("n", "<leader>cl", toggle_claude, { desc = "Claude" })
		end,
	},
}
