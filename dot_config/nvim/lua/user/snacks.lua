local actions = {
  cd_up0 = function(picker, _)
    picker:set_cwd(".")
    picker:find()
  end,
  cd_up1 = function(picker, _)
    picker:set_cwd("..")
    picker:find()
  end,
  cd_up2 = function(picker, _)
    picker:set_cwd("../..")
    picker:find()
  end,
  cd_up3 = function(picker, _)
    picker:set_cwd("../../..")
    picker:find()
  end,
}
local win = {
  input = {
    keys = {
      ["<c-0>"] = { "cd_up0", desc = "change dir .", mode = { "i", "n" } },
      ["<c-1>"] = { "cd_up1", desc = "change dir ..", mode = { "i", "n" } },
      ["<c-2>"] = { "cd_up2", desc = "change dir ...", mode = { "i", "n" } },
      ["<c-3>"] = { "cd_up3", desc = "change dir ....", mode = { "i", "n" } },
    },
  },
}

require("snacks").setup(
  {
    input = { enabled = true },
    git = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    words = { enabled = false },
    gitbrowse = { enabled = true }, --
    statuscolumn = { enabled = false },
    quickfile = { enabled = true },
    bufdelete = { enabled = true },
    scroll = { enabled = false },
    picker = {
      enabled = true,
      layout = {
        preview = "split",
        preset = "default",
      },
      sources = {
        explorer    = {
          auto_close = true,
          focus = "input",
          layout = {
            preview = "split",
            preset = "default",
          },
          actions = actions,
          win = win,
        },
        diagnostics = {
          filter = { cwd = false }
        },
        files       = { actions = actions, win = win },
        grep        = { actions = actions, win = win },
      }
    },
    explorer = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        -- { section = "header" },
        -- { section = "keys", gap = 1, padding = 1 },
        -- { section = "startup" },
        {
          pane = 1,
          icon = "",
          title = "",
          -- section = "terminal",
          -- enabled = vim.fn.isdirectory(".git") == 1,
          -- cmd = "echo ' '",
          -- height = 5,
          -- padding = 1,
          -- ttl = 5 * 60,
          -- indent = 3,
        },
        -- { section = "header" },
        -- { section = "keys", gap = 1, padding = 1 },
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')", padding = 1 },
        -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        -- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        -- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
        -- { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        -- { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", padding = 1 },
        { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", limit = 8, padding = 1 },
        { pane = 1, title = "Recent Files(cwd)", section = "recent_files", cwd = true, limit = 8, padding = 1 },
        { section = "startup" },
      },
    },
    bigfile = { enabled = true },
  }
)
