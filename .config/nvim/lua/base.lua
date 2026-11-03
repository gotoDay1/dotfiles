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
    laststatus = 3,
    updatetime = 300
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

local transparent_groups = { "Normal", "LineNr", "SignColumn", "EndOfBuffer" }
for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
end

vim.opt.termguicolors = true
vim.opt.updatetime = 300

home = vim.fn.expand("$HOME")

