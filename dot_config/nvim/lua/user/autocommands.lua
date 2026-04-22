vim.cmd [[
autocmd FileType norg setlocal conceallevel=2
autocmd FileType markdown setlocal conceallevel=2

augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END
]]


vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt.textwidth = 80
    vim.opt.wrap = true
    vim.opt.formatoptions:append("m")
    vim.opt.formatoptions:append("B")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "wgsl",
  callback = function()
    vim.opt_local.shiftwidth = 4
  end,
})


vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.wesl", command = "setfiletype wesl" })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.wgsl", command = "setfiletype wgsl" })

local timer = vim.loop.new_timer()
timer:start(1000, 1000, vim.schedule_wrap(function()
  if vim.fn.getcmdwintype() == "" then
    vim.cmd("checktime")
  end
end))


vim.cmd([[cab cc CopilotChat]])

-- Check if we are in an SSH session
if os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil then
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      -- vim.highlight.on_yank()
      local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
      copy_to_unnamedplus(vim.v.event.regcontents)
      local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
      copy_to_unnamed(vim.v.event.regcontents)
    end,
  })
end


-- Enable spell checking only for specific file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "gitrebase", "tex", "rst", "plaintex", "context" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
