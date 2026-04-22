vim.filetype.add({
  extension = {
    urdf = "xml",
    xacro = "xml",
    launch = "xml", -- Useful for ROS launch files too!
  },
})

vim.api.nvim_create_user_command('PasteImage', function()
  -- Get current file's directory
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if filepath == '' then
    vim.notify('Buffer has no file path', vim.log.levels.ERROR)
    return
  end

  local current_dir = vim.fn.fnamemodify(filepath, ':p:h')
  local assets_dir = current_dir .. '/assets'

  -- Create assets directory if it doesn't exist
  vim.fn.mkdir(assets_dir, 'p')

  -- Generate filename with timestamp and random hash
  local timestamp = os.date('%Y%m%d_%H%M%S')
  local hash = string.sub(vim.fn.system('echo $RANDOM | md5 | cut -c1-8'), 1, 8)
  local filename = string.format('%s_%s.png', timestamp, hash)
  local full_path = assets_dir .. '/' .. filename

  -- Save image using pngpaste
  vim.fn.system('pngpaste "' .. full_path .. '"')

  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to paste image. Is pngpaste installed?', vim.log.levels.ERROR)
    return
  end

  -- Insert markdown link at cursor position
  local markdown_link = string.format('![img](assets/%s)', filename)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(bufnr, row - 1, col, row - 1, col, { markdown_link })

  -- Move cursor after the inserted text
  vim.api.nvim_win_set_cursor(0, { row, col + #markdown_link })

  vim.notify('Image saved: ' .. filename, vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("CopyGitPath", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root == nil or git_root == '' then
    print("Not in a git repo")
    return
  end
  local filepath = vim.fn.expand("%:p")
  local relpath = string.gsub(filepath, git_root .. "/", "")
  vim.fn.setreg("+", relpath)
  print("Copied relative path: " .. relpath)
end, {})

local M = {}

M.cargo_add = function()
  local word = vim.fn.expand("<cword>")
  local command = { "cargo", "add", word }

  print("!cargo add " .. word)
  -- vim.fn.system(command)
  vim.system(command, { text = true }, function(obj)
    if obj.code == 0 then
      print("✅ Added: " .. word)
    else
      print("❌ Failed to add: " .. word)
      print(obj.stderr)
    end
  end)
end

M.open_cursor = function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  vim.fn.system(string.format('cursor --goto "%s:%d"', file, line))
end

M.open_agy = function()
  local file = vim.fn.expand("%:p")
  local line = vim.fn.line(".")
  vim.fn.system(string.format('agy --goto "%s:%d"', file, line))
end

M.cargo_add_with_extras = function()
  Snacks.input({
    prompt = "Enter a value: ",
  }, function(extras)
    if extras then
      -- local word = vim.fn.expand("<cword>")
      -- local command = "cg add " .. word .. " " .. extras
      -- print("!" .. command)
      -- vim.fn.system(command)

      local word = vim.fn.expand("<cword>")
      local command = { "cargo", "add", word, extras }

      print("!cargo add " .. word .. ' ' .. extras)
      -- vim.fn.system(command)
      vim.system(command, { text = true }, function(obj)
        if obj.code == 0 then
          print("✅ Added: " .. word)
        else
          print("❌ Failed to add: " .. word)
          print(obj.stderr)
        end
      end)
    end
  end)
end

M.collect_and_remove_todos = function()
  local journal_dir = "/Users/haoyuan/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes/Journal/"
  local current_file = vim.fn.expand("%:p")
  if not current_file:find(journal_dir, 1, true) then
    require("notify")("Current file is not in the Journal directory.", "warn")
    return
  end
  local files = vim.fn.glob(journal_dir .. "*.md", true, true)
  local todos = {}
  for _, file in ipairs(files) do
    if file ~= current_file then
      local lines = vim.fn.readfile(file)
      local new_lines = {}
      local removed = false

      for _, line in ipairs(lines) do
        if line:match("%- %[ %]") then
          table.insert(todos, line)
          removed = true
        else
          table.insert(new_lines, line)
        end
      end

      if removed then
        vim.fn.writefile(new_lines, file)
      end
    end
  end

  -- Add a blank line before insertion for separation
  vim.api.nvim_put(todos, "l", true, true)
end

M.fd = function()
  Snacks.input({
    prompt = "CWD: ",
  }, function(cwd)
    if cwd then
      -- local word = vim.fn.expand("<cword>")
      -- local command = "cg add " .. word .. " " .. extras
      -- print("!" .. command)
      -- vim.fn.system(command)
      require("fzf-lua").files({ cwd = cwd })
    end
  end)
end

M.switch_case = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word = vim.fn.expand('<cword>')
  local word_start = vim.fn.matchstrpos(vim.fn.getline('.'), '\\k*\\%' .. (col + 1) .. 'c\\k*')[2]

  if word:find('^[A-Z][a-z]') then
    -- PascalCase to camelCase
    local camal_case = word:gsub('^([A-Z])', function(l) return l:lower() end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camal_case })
  elseif word:find('[a-z][A-Z]') then
    -- camelCase to snake_case
    local snake_case = word:gsub('([a-z])([A-Z])', '%1_%2'):lower()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case })
  elseif word:find('_[a-z]') then
    -- snake_case to kebab-case
    local snake_case_v2 = word:gsub('_(.)', function(l) return '-' .. l end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_v2 })
  elseif word:find('-[a-z]') then
    -- kebab-case to ABC_DEF
    local abc_def = word:gsub('-(.)', function(l) return '_' .. l end):upper()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { abc_def })
  elseif word:find('^[A-Z0-9_]+$') and word:find('_') then
    -- ABC_DEF to PascalCase
    local pascal_case = word:lower():gsub('_(.)', function(l) return l:upper() end)
    pascal_case = pascal_case:gsub('^.', function(l) return l:upper() end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { pascal_case })
  else
    -- toggle capitalized first
    local toggled = word:gsub('^.', function(l) return l:upper() end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { toggled })
  end
end

return M
