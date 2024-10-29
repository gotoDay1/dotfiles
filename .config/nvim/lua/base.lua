local options = {
    -- encoding
	encoding = "utf-8",
	fileencoding = "utf-8",
    
    -- tab
	smartindent = true,
	expandtab = true,
	showtabline = 4,
	shiftwidth = 4,
	tabstop = 4,

    -- visual
	title = true,
	cursorline = true,
    signcolumn = "yes",

    -- number
	number = true,
	relativenumber = true,
	numberwidth = 4,

    -- clipboard
	clipboard = "unnamedplus",

    -- undo, swap
	undofile = true,
    undodir = vim.fn.stdpath("cache") .. "/undo",

    -- disable backup
	swapfile = false,
    backup = false,
    writebackup = false,
    
    -- search 
	smartcase = true,
    ignorecase = true,
	hlsearch = true,

    -- etc
	mouse = "a",
	shell = "zsh",
    updatetime = 300
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.termguicolors = true
vim.cmd("highlight Normal ctermbg=none guibg=none")
vim.cmd("highlight LineNr ctermbg=none guibg=none")
vim.cmd("highlight SignColumn ctermbg=none guibg=none")
vim.cmd("highlight EndOfBuffer ctermbg=none guibg=none")

-- Coc
vim.cmd [[
  autocmd FileType tex setlocal omnifunc=v:lua.vim.lsp.omnifunc
]]
vim.g.coc_filetype_map = { tex = 'latex' }

-- pyx は python として扱う
vim.filetype.add({
    extension = {
        pyx = "python"
    }
})

