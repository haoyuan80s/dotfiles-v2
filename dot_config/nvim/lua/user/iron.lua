local iron = require("iron.core")
local view = require("iron.view")

iron.setup {
  config = {
    repl_definition = {
      sh = {
        -- Can be a table or a function that
        -- returns a table (see below)
        command = { "fish" }
      },
      -- haskell = {
      --   command = function(meta)
      --     local file = vim.api.nvim_buf_get_name(meta.current_bufnr)
      --     -- call `require` in case iron is set up before haskell-tools
      --     return require('haskell-tools').repl.mk_repl_cmd(file)
      --   end,
      -- },
    },
    repl_open_cmd = view.split.vertical.botright(0.5)
  },

  -- `view.center` takes either one or two arguments
}
