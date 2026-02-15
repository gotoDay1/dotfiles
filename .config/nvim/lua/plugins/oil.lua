return {
	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		-- opts に設定を直接書く（自動で setup() に渡される）
		opts = {
			default_file_explorer = true,
			columns = { "icon" },
			float = {
				padding = 2,
				max_width = 90,
				max_height = 0,
				border = "rounded",
			},
		},
		-- キーマッピングだけは別途設定が必要
		keys = {
			{
				"<leader>o",
				function()
					require("oil").toggle_float()
				end,
				desc = "Oil Float",
			},
		},
	},
}
