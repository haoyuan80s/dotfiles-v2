vim.env.LAZY_STDPATH = '.repro'
---@diagnostic disable-next-line: param-type-mismatch
load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()

require('lazy.minit').repro {
  spec = {
    {
      "neovim/nvim-lspconfig",
      inlay_hints = { enabled = true },
      config = function()
        require("user.lsp.lsp")
      end,
      dependencies = {
        { "williamboman/mason.nvim" },
        -- { "williamboman/mason-lspconfig.nvim" },
        -- { "lukas-reineke/lsp-format.nvim", enabled = false },
      }
    },
    {
      'mrcjkb/rustaceanvim',
      version = '^6',
      init = function()
        -- Configure rustaceanvim here
        vim.g.rustaceanvim = {}
      end,
      lazy = false,
    },
  },
}
