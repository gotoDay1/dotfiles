return{
    {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        config = function()
            -- Set up nvim-cmp.
      local cmp = require'cmp'
        cmp.setup({})
        end,
    }
}
