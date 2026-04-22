require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = false,
    selection_modes = {
      ["@parameter.outer"] = "v",
      ["@function.outer"] = "V",
      ["@class.outer"] = "<c-v>",
    },
    include_surrounding_whitespace = true,
  },
  move = {
    set_jumps = true,
  },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- select
vim.keymap.set({ "x", "o" }, "aa", function()
  select.select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
  select.select_textobject("@parameter.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "af", function()
  select.select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
  select.select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
  select.select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "is", function()
  select.select_textobject("@class.inner", "textobjects")
end)

-- swap
vim.keymap.set("n", "gsa", function()
  swap.swap_next("@parameter.inner")
end)
vim.keymap.set("n", "gsA", function()
  swap.swap_previous("@parameter.inner")
end)

-- move
vim.keymap.set({ "n", "x", "o" }, "]f", function()
  move.goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]c", function()
  move.goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]F", function()
  move.goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]C", function()
  move.goto_next_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[f", function()
  move.goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[c", function()
  move.goto_previous_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[F", function()
  move.goto_previous_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[C", function()
  move.goto_previous_end("@class.outer", "textobjects")
end)
