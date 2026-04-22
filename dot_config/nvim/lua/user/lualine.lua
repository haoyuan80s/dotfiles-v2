local lualine = require("lualine")

local filename = {
  "filename",
  newfile_status = true,
  path = 0, -- 0: Just the filename
  -- 1: Relative path
  -- 2: Absolute path
  -- 3: Absolute path, with tilde as the home directory
  symbols = {
    modified = '[+]',      -- Text to show when the file is modified.
    readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
    unnamed = '[No Name]', -- Text to show for unnamed buffers.
    newfile = '[New]',     -- Text to show for new created file before first writting
  }
}

local function search_result()
  if vim.v.hlsearch == 0 then
    return ''
  end
  -- local last_search = vim.fn.getreg('/')
  -- if not last_search or last_search == '' then
  --   return ''
  -- end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  -- return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
  return '[' .. searchcount.current .. '/' .. searchcount.total .. ']'
end

--
local function tab_num()
  if #vim.api.nvim_list_tabpages() > 1 then
    return tostring(vim.fn.tabpagenr())
  else
    return ''
  end
end

local function window_num()
  if #vim.api.nvim_list_wins() > 1 then
    return tostring(vim.fn.winnr())
  else
    return ''
  end
end

lualine.setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { window_num, "mode" },
    lualine_b = { tab_num, filename, },
    lualine_c = { "aerial" },
    lualine_x = {
      function()
        return require('lsp-progress').progress()
      end,
      search_result, "diagnostics", "diff", "progress", "location", "filetype", "branch", },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_a = { window_num },
    lualine_b = { tab_num, filename, },
    lualine_c = { "progress", "location" },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})
