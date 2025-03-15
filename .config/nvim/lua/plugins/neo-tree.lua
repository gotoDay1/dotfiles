return{
    {
      "nvim-neo-tree/neo-tree.nvim",
      event = "BufWinEnter",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      },
      config = function()
          vim.keymap.set("n", "<C-a>", ":Neotree source=filesystem toggle=true position=float reveal=true <CR>")
      end
    }
}
