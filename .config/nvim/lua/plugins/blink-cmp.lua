return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets", -- スニペット集
		"L3MON4D3/LuaSnip", -- スニペットエンジン
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "super-tab",
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		snippets = {
			preset = "luasnip",
		},
		completion = { documentation = { auto_show = true }, auto_brackets = { enabled = true } },
		sources = {
			default = { "snippets", "lsp", "path", "buffer" },
		},
		fuzzy = {
			-- versionを指定してないとバイナリが特定できずLuaにfallbackするwarningが表示される
			implementation = "prefer_rust_with_warning",
		},
	},
	opts_extend = { "sources.default" },
}
