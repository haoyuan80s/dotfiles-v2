local Snacks = require("snacks")
local which_key = require("which-key")


vim.cmd [[
function! QuitUnmodifialbe()
    if !&modifiable
        execute "bd"
    endif
endfunction

function! Preserve(command)
  let w = winsaveview()
  execute a:command
  call winrestview(w)
endfunction
]]

function ToggleWrap()
  if vim.wo.wrap then
    vim.wo.wrap = false
    print("Line wrap OFF")
  else
    vim.wo.wrap = true
    print("Line wrap ON")
  end
end

local function get_end_col(line, col)
  if #line == 0 then
    return 0
  end

  col = math.min(col, #line)
  local prefix_char_count = vim.fn.strchars(string.sub(line, 1, col - 1))
  local char = vim.fn.strcharpart(line, prefix_char_count, 1)
  return col + #char - 1
end

local function get_range_lines(mode)
  local start_line, end_line, start_col, end_col

  if mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
    local l1 = vim.fn.line("v")
    local l2 = vim.fn.line(".")
    local c1 = vim.fn.col("v")
    local c2 = vim.fn.col(".")

    if mode == "V" or mode == "S" then
      start_line = math.min(l1, l2)
      end_line = math.max(l1, l2)
    elseif mode == "\22" or mode == "\19" then
      start_line = math.min(l1, l2)
      end_line = math.max(l1, l2)
      start_col = math.min(c1, c2)
      end_col = math.max(c1, c2)
    else
      if l1 < l2 or (l1 == l2 and c1 <= c2) then
        start_line, end_line = l1, l2
        start_col, end_col = c1, c2
      else
        start_line, end_line = l2, l1
        start_col, end_col = c2, c1
      end
    end
  else
    start_line = vim.fn.line(".")
    end_line = start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  if (mode == "v" or mode == "s") and start_col and end_col then
    start_col = math.max(start_col, 1)
    if #lines == 1 then
      local ec = get_end_col(lines[1], end_col)
      lines[1] = string.sub(lines[1], start_col, ec)
    elseif #lines > 1 then
      lines[1] = string.sub(lines[1], start_col)
      local ec = get_end_col(lines[#lines], end_col)
      lines[#lines] = string.sub(lines[#lines], 1, ec)
    end
  elseif (mode == "\22" or mode == "\19") and start_col and end_col then
    start_col = math.max(start_col, 1)
    for i = 1, #lines do
      local ec = get_end_col(lines[i], end_col)
      lines[i] = string.sub(lines[i], start_col, ec)
    end
  end

  return start_line, end_line, lines
end

which_key.add {
  { "<C-W>1",            "1<C-W>w",                 desc = "Go to window 1", },
  { "<C-W>2",            "2<C-W>w",                 desc = "Go to window 2", },
  { "<C-W>3",            "3<C-W>w",                 desc = "Go to window 3", },
  { "<C-W>4",            "4<C-W>w",                 desc = "Go to window 4", },
  { "<C-W>5",            "5<C-W>w",                 desc = "Go to window 5", },
  { "<C-W>6",            "6<C-W>w",                 desc = "Go to window 6", },
  { "<C-W>7",            "7<C-W>w",                 desc = "Go to window 7", },
  { "<C-W>8",            "8<C-W>w",                 desc = "Go to window 8", },
  { "<leader><leader>u", "<cmd>UndotreeToggle<CR>", desc = "UndoTree", },
  { "<leader><leader>w", ToggleWrap,                desc = "ToggleWrap" },
  { "<leader><leader>l", "<cmd>Lazy<CR>",           desc = "Lazy", },
  { "<leader><leader>m", "<cmd>Mason<CR>",          desc = "Mason", },
  { "<leader>:", function() Snacks.picker.command_history({ layout = { preset = "default", preview = false } }) end,
    desc = "Command History" },
  { "<leader>.",  "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Action", },
  { "<leader>/",  "<cmd>ChatGPT<CR>",                       desc = "ChatGPT", },
  { "<leader>=",  '<cmd>let @+=@"<CR>',                     desc = "To system register", },
  { "<leader>D",  group = "Database", },
  { "<leader>Df", "<cmd>DBUIFindBuffer<CR>",                desc = "Find", },
  { "<leader>Dl", "<cmd>DBUILastQueryInfo<CR>",             desc = "Last Query", },
  { "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>",              desc = "Rename", },
  { "<leader>Dt", "<cmd>DBUIToggle<CR>",                    desc = "Toggle", },
  { "ZX",         function() Snacks.bufdelete() end,        desc = "Kill Buffer", },
  { "<leader>b",  group = "Buffer", },
  { "<leader>bD", "<cmd>:%bd!|e#|bp|bw<CR>",
    desc = "Kill Other Buffer", },
  { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Buffers", },
  { "<leader>bd", function() Snacks.bufdelete() end,
    desc = "Kill Buffer", },
  { "<leader>bn", "<cmd>bn<CR>",                          desc = "Next Buffer", },
  { "<leader>bp", "<cmd>bp<CR>",                          desc = "PreviousBuffer", },
  { "<leader>br", "<cmd>e!<CR>",                          desc = "Refresh Buffer", },
  { "<leader>c",  group = "Code", },
  {
    "<leader>cE",
    function()
      Snacks.picker.diagnostics({
        severity = vim.diagnostic.severity.ERROR, -- ← only show errors
      })
    end,
    desc = "Diagnostics (Errors only)",
  },
  {
    "<leader>c<c-e>",
    function()
      Snacks.picker.diagnostics_buffer({
        severity = vim.diagnostic.severity.ERROR, -- ← only show errors in current buffer
      })
    end,
    desc = "Diagnostics buffer (Errors only)",
  },
  { "<leader>cD",     function() Snacks.picker.diagnostics() end,        desc = "Diagnostics", },
  { "<leader>c<c-d>", function() Snacks.picker.diagnostics_buffer() end, desc = "Diagnostics buffer", },
  { "<leader>cd",     "<cmd>lua vim.diagnostic.open_float()<CR>",        desc = "Float Diagnostics", },
  { "<leader>cv", "<cmd>lua ToggleVirtualText()<cr>",
    desc = "Document Diagnostics", },
  { "<leader>cL", "<cmd>lua vim.lsp.codelens.enable(true, { bufnr = bufnr })<cr>",
    desc = "CodeLens refresh", },
  { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
  { "<leader>cb", "<cmd>DapToggleBreakpoint<cr>",
    desc = "Breakpoint", },
  -- { "<leader>cc", "<cmd>execute 'ToggleCopilot'<cr>", desc = "ToggleCopilot", },

  { "<leader>cc", require("user.hao_play").open_cursor,     desc = "Open Cursor at line" },
  { "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>",
    desc = "Fomat", },
  { "<leader>ci", "<cmd>checkhealth vim.lsp<cr>",
    desc = "Info", },
  { "<leader>cj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
    desc = "Next Diagnostic", },
  { "<leader>ck", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
    desc = "Prev Diagnostic", },
  { "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<cr>",
    desc = "CodeLens Action", },
  { "<leader>co",     "<cmd>AerialToggle!<cr>",                                     desc = "Outline", },
  { "<leader>cq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>",
    desc = "Quickfix", },
  { "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>",
    desc = "Rename", },
  { "<leader>ct", "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>",
    desc = "Type hint", },
  { "<leader>cp", "<cmd>Copilot panel<cr>",
    desc = "Type hint", },
  -- { "<leader>d",      "<cmd>Oil --float<cr>",
  -- desc = "Dir",                               },
  { "<leader>f",      group = "File", },
  { "<leader>fg",     function() Snacks.picker.git_files({ untracked = true }) end, desc = "Git Files", },

  { "<leader>f<c-s>", "<cmd>noa w<CR>",                                             desc = "Save noautocmd", },
  { "<leader>fS",     "<cmd>wa<CR>",                                                desc = "Save All", },

  { "<leader>o",      group = "Open", },
  { "<leader>oc",     require("user.hao_play").open_cursor,                         desc = "Open Cursor at line" },
  { "<leader>oa",     require("user.hao_play").open_agy,                            desc = "Open agy at line" },

  { "<leader>y",      group = "Yank",                                               mode = { "n", "v" } },
  { "<leader>yf",     '<cmd>let @+ = expand("%:p")<CR><esc>',                       desc = "Copy file path", },
  {
    "<leader>yp",
    function()
      local path = vim.fn.expand("%:p")
      vim.fn.setreg("+", path)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end,
    desc = "Copy file path",
  },
  {
    "<leader>yP",
    function()
      local dir = vim.fn.expand("%:p:h")
      vim.fn.setreg("+", dir)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end,
    desc = "Copy file dir",
  },
  {
    "<leader>yl",
    function()
      local path = vim.fn.expand("%:p")
      local mode = vim.fn.mode()
      local start_line, end_line, lines = get_range_lines(mode)
      local formatted_lines = {}

      if start_line == end_line then
        table.insert(formatted_lines, string.format("%s:%d", path, start_line))
      else
        table.insert(formatted_lines, string.format("%s:%d-%d", path, start_line, end_line))
      end

      for i, line in ipairs(lines) do
        local line_num = start_line + i - 1
        table.insert(formatted_lines, string.format("%d: %s", line_num, line))
      end

      vim.fn.setreg("+", table.concat(formatted_lines, "\n") .. "\n")

      if mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      end
    end,
    mode = { "n", "x", "s" },
    desc = "Copy line/range content with line numbers and file path",
  },
  { "<leader>y<c-f>", '<cmd>CopyGitPath<CR>',                 desc = "Copy file git path", },
  { "<leader>yF",     '<cmd>let @+ = expand("%:n")<CR><esc>', desc = "Copy file path", },

  { "<leader>fe", "<cmd>e<cr>",
    desc = "Reedit file", },
  { "<leader>ff", Snacks.explorer.open,                                                       desc = "Files browser", },
  { "<leader>fd", Snacks.picker.files,                                                        desc = "fd" },
  { "<leader>fr", Snacks.picker.recent,                                                       desc = "Open Recent File", },
  { "<leader>fs", "<cmd>w!<CR>",                                                              desc = "Save", },
  { "<leader>fx", "<cmd>let f=expand('%') | call delete(f) | echo 'Deleted: ' . f | bw!<CR>", desc = "Delete buffer file" },
  { "<leader>g",  group = "Git", },
  { "<leader>gg", function() Snacks.lazygit() end,                                            desc = "Lazygit", },
  { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",                             desc = "Reset hunk", },
  { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",                           desc = "Reset Buffer", },
  { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",                        desc = "Undo Stage Hunk", },
  { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",                             desc = "Stage Hunk", },
  { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>",                             desc = "Blame", },
  { "<leader>gc", "<cmd>GitBlameCopyFileURL<cr>",                                             desc = "GitBlameCopyFileURL", },
  { "<leader>gt", "<cmd>GitBlameToggle<cr>",                                                  desc = "GitBlameToggle", },
  { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>",                                          desc = "Diff", },

  { "<leader>h",  group = "Help", },
  { "<leader>hn", function() Snacks.notifier.show_history() end,                              desc = "Notify history", },
  { "<leader>hc", function() Snacks.picker.commands() end,                                    desc = "Commands" },
  { "<leader>hh", function() Snacks.picker.help() end,                                        desc = "Help Tags" },
  { "<leader>hk", function() Snacks.picker.keymaps() end,                                     desc = "Keymaps" },
  { "<leader>'",  function() Snacks.picker.marks() end,                                       desc = "Marks" },

  { "<leader>s",  group = "Search", },
  { "<leader>sn", "<cmd>Obsidian search<cr>",                                                 desc = "Notes", },
  { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,                       desc = "LSP Workspace Symbols" },
  { "<leader>sg", function() Snacks.picker.grep({ live = true, show_empty = true }) end,      desc = "Live Grep (cwd)" },
  { "<leader>sG", function() Snacks.picker.git_grep({ live = true, show_empty = true }) end,  desc = "Git Grep" },
  { "<leader>ss", function() Snacks.picker.lsp_symbols() end,                                 desc = "Symbols (Document)" },
  { "<leader>sw", function() Snacks.picker.grep_word() end,                                   desc = "Grep Word Under Cursor" },

  { "<leader>t",  group = "Tab", },
  { "<leader>tn", "<cmd>tab split<CR>",                                                       desc = "New", },
  { "<leader>tx", "<cmd>tabclose<CR>",                                                        desc = "Close", },

  { "<leader>n",  group = "Notes", },
  { "<leader>nn", "<cmd>e /Users/haoyuan/notes/<cr>",                                         desc = "notes", },
  { "<leader>ns", "<cmd>Obsidian search<cr>",                                                 desc = "Search", },
  { "<leader>nt", "<cmd>Obsidian tags<cr>",                                                   desc = "Tags", },
  { "<leader>nj", "<cmd>Obsidian today<cr>",                                                  desc = "Journal Today", },
  { "<leader>n1", "<cmd>Obsidian today +1<cr>",                                               desc = "Journal Tomorrow", },
  { "<leader>ny", "<cmd>Obsidian today -1<cr>",                                               desc = "Journal Yesterday", },

  { "<leader>m",  group = "Mode specific", },


  { "<leader>a",  mode = { "n", "v" },                                                        group = "Agent", },
  { "<leader>aa", mode = { "n", "v" },                                                        "<cmd>CopilotChatToggle<CR>",   desc = "Agent Toggle", },
  { "<leader>ar", mode = { "n", "v" },                                                        "<cmd>CopilotChatReset<CR>",    desc = "Agent Reset", },
  { "<leader>as", mode = { "n", "v" },                                                        "<cmd>CopilotChatStop<CR>",     desc = "Agent Stop", },
}

function GetCurrentFileName()
  local filename = vim.fn.expand("%:t")
  return filename
end

-- which_key.add(leader_mappings, {
--   -- mode = {"n", "v", "o"},     -- NORMAL mode
--   -- prefix = "<leader>",
--   buffer = nil,   -- Global map for buffer local mappings
--   silent = true,  -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--     -- use `nowait` when creating keymaps
-- })

-- which_key.register(leader_mappings, {
--   mode = "v",     -- NORMAL mode
--   prefix = "<leader>",
--   buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true,  -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--     -- use `nowait` when creating keymaps
-- })
-- which_key.register(leader_mappings, {
--   mode = "o",     -- NORMAL mode
--   prefix = "<leader>",
--   buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true,  -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--     -- use `nowait` when creating keymaps
-- })
--
-- which_key.register(leader_mappings, {
--   mode = "i",     -- NORMAL mode
--   prefix = "<c-space>",
--   buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true,  -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--     -- use `nowait` when creating keymaps
-- })
--


function FileSpecificKeybinding()
  local fileType = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  -- local buf = vim.api.nvim_get_current_buf()
  local fileName = vim.api.nvim_buf_get_name(0)
  -- split by / and get the last element
  fileName = fileName:match("^.+/(.+)$")

  if fileName == 'Cargo.toml' then
    which_key.add({
      {
        "<leader>mD",
        "<cmd>lua require('crates').open_documentation()<CR>",
        desc = "crate doc"
      },
      {
        "<leader>mH",
        "<cmd>lua require('crates').open_homepage()<CR>",
        desc = "crate homepage"
      },
      {
        "<leader>mo",
        "<cmd>lua require('crates').open_crates_io()<CR>",
        desc = "crate io"
      },
      {
        "<leader>mR",
        "<cmd>lua require('crates').open_repository()<CR>",
        desc = "crate repo"
      },
      {
        "<leader>mU",
        "<cmd>lua require('crates').update_all_crate()<CR>",
        desc = "crate update all"
      },
      {
        "<leader>md",
        "<cmd>lua require('crates').show_dependencies_popup()<CR>",
        desc = "crate show_dependencies_popup"
      },
      {
        "<leader>mf",
        "<cmd>lua require('crates').show_features_popup()<CR>",
        desc = "crate features"
      },
      {
        "<leader>mp",
        "<cmd>lua require('crates').show_popup()<CR>",
        desc = "crate popup"
      },
      {
        "<leader>mr",
        "<cmd>lua require('crates').reload()<CR>",
        desc = "crate reload"
      },
      {
        "<leader>mt",
        "<cmd>lua require('crates').toggle()<CR>",
        desc = "crate toggle"
      },
      {
        "<leader>mu",
        "<cmd>lua require('crates').update_crate()<CR>",
        desc = "crate update"
      },
      {
        "<leader>mv",
        "<cmd>lua require('crates').show_versions_popup()<CR>",
        desc = "crate versions"
      },
      buffer = true
    }
    )
  elseif fileType == 'dap-repl' then
    which_key.add({
      {
        "<leader>mX",
        "<cmd>DapTerminate<cr>",
        desc = "Terminate"
      },
      {
        "<leader>mc",
        "<cmd>DapContinue<cr>",
        desc = "Continue"
      },
      {
        "<leader>mn",
        "<cmd>DapStepOver<cr>",
        desc = "Step over"
      },
      {
        "<leader>mo",
        "<cmd>DapStepOut<cr>",
        desc = "Step out"
      },
      {
        "<leader>mr",
        "<cmd>DapRerun<cr>",
        desc = "Rerun"
      },
      {
        "<leader>ms",
        "<cmd>DapStepInto<cr>",
        desc = "Step into"
      },
      {
        "<leader>mt",
        "<cmd>DapToggleRepl<cr>",
        desc = "Repl"
      },
      {
        "<leader>mx",
        "<cmd>DapStop<cr>",
        desc = "Stop"
      },
      buffer = true
    })
  elseif fileType == 'glsl' then
    which_key.add({
      {
        "<leader>mm",
        "<cmd>GlslView<CR>",
        desc = "GlslView"
      },
      buffer = true
    })
  elseif fileType == 'idris2' then
    which_key.add({
      {
        "<leader>ma",
        "<cmd>lua require('idris2.code_action').expr_search()<CR>",
        desc = "auto"
      },
      {
        "<leader>mc",
        "<cmd>lua require('idris2.code_action').case_split()<CR>",
        desc = "case_split"
      },
      {
        "<leader>mg",
        "<cmd>lua require('idris2.code_action').generate_def()<CR>",
        desc = "auto"
      },
      {
        "<leader>mi",
        "<cmd>lua require('idris2.code_action').intro()<CR>",
        desc = "intro"
      },
      {
        "<leader>mm",
        "<cmd>lua require('idris2.code_action').add_clause()<CR>",
        desc = "intro"
      },
      {
        "<leader>mr",
        "<cmd>lua require('idris2.code_action').refine_hole()<CR>",
        desc = "refine_hole"
      },
      buffer = true
    })
  elseif fileType == "rust" then
    which_key.add({
      {
        "<leader>me",
        '<cmd>RustLsp expandMacro<CR>',
        desc = "expandMacro"
      },
      {
        "<leader>md",
        '<cmd>RustLsp relatedDiagnostics<CR>',
        desc = "relatedDiagnostics"
      },
      {
        "<leader>mo",
        '<cmd>RustLsp openDocs<CR>',
        desc = "openDocs"
      },
      {
        "<leader>mr",
        '<cmd>RustLsp rebuildProcMacros<CR>',
        desc = "rebuildProcMacros"
      },
      {
        "<leader>mA",
        '<cmd>lua require("user.hao_play").cargo_add_with_extras()<CR>',
        desc = "Runnables with args"
      },
      {
        "<leader>ma",
        '<cmd>lua require("user.hao_play").cargo_add()<CR>',
        desc = "Runnables"
      },
      {
        "<leader>mc",
        "<cmd>RustLsp openCargo<CR>",
        desc = "OpenCargoToml"
      },
      {
        "<leader>ml",
        "<cmd>!leptosfmt ./**/*.rs<CR>",
        desc = "leptosfmt"
      },
      buffer = true
    })
  elseif fileName == "project.yml" or fileType == "swift" then
    which_key.add({
      {
        "<leader>m<c-n>",
        "<cmd>XcodebuildJumpToNextCoverage<CR>",
        desc = "Jump To Next Coverage"
      },
      {
        "<leader>m<c-p>",
        "<cmd>XcodebuildJumpToPrevCoverage<CR>",
        desc = "Jump To Previous Coverage"
      },
      {
        "<leader>mC",
        "<cmd>XcodebuildShowCodeCoverageReport<CR>",
        desc = "Show Code Coverage Report"
      },
      {
        "<leader>mb",
        "<cmd>XcodebuildBuild<CR>",
        desc = "Build Project"
      },
      {
        "<leader>mc",
        "<cmd>XcodebuildToggleCodeCoverage<CR>",
        desc = "Toggle Code Coverage"
      },
      {
        "<leader>md",
        "<cmd>XcodebuildSelectDevice<CR>",
        desc = "Select Device"
      },
      {
        "<leader>me",
        "<cmd>XcodebuildTestExplorerToggle<CR>",
        desc = "Toggle Test Explorer"
      },
      {
        "<leader>mf",
        "<cmd>XcodebuildProjectManager<CR>",
        desc = "Show Project Manager Actions"
      },
      {
        "<leader>ml",
        "<cmd>XcodebuildToggleLogs<CR>",
        desc = "Toggle Xcodebuild Logs"
      },
      {
        "<leader>mm",
        "<cmd>XcodebuildPicker<CR>",
        desc = "Show All Xcodebuild Actions"
      },
      {
        "<leader>mp",
        "<cmd>XcodebuildSelectTestPlan<CR>",
        desc = "Select Test Plan"
      },
      {
        "<leader>mr",
        "<cmd>XcodebuildBuildRun<CR>",
        desc = "Build & Run Project"
      },
      { "<leader>ms",  "<cmd>XcodebuildFailingSnapshots<CR>", desc = "Show Failing Snapshots" },
      { "<leader>mt",  group = "test" },
      { "<leader>mtT", "<cmd>XcodebuildTestTarget<CR>",       desc = "Run This Test Target" },
      { "<leader>mtc", "<cmd>XcodebuildTestClass<CR>",        desc = "Run This Test Class" },
      { "<leader>mtt", "<cmd>XcodebuildTest<CR>",             desc = "Run Tests" },
      buffer = true
    })
  elseif fileType == 'markdown' then
    which_key.add({

      { "<leader>mp", "<cmd>PasteImage<CR>",                             desc = "PasteImage", },
      { "<leader>mw", "<cmd>silent! !open %<CR>",                        desc = "Watch" },
      { "<leader>mg", require("user.hao_play").collect_and_remove_todos, desc = "Grab todo" },
      buffer = true
    })
  elseif fileType == 'sql' then
    which_key.add({
      { "<leader>me", "<Plug>(DBUI_EditBindParameters)", desc = "EditBindParameters" },
      { "<leader>mm", "<cmd>DBUIToggle<CR>",             desc = "DBUIToggle" },
      { "<leader>ms", "<Plug>(DBUI_SaveQuery)",          desc = "SaveQuery" },
      buffer = true
    })
  elseif fileType == 'lua' then
    which_key.add({
      { "<leader>ml", "<cmd>w | so %<CR>", desc = "Load Buffer", },
      buffer = true
    })
  elseif fileType == 'haskell' then
    which_key.add({
      { "<leader>mc", "<cmd>HsPackageCabal<CR>",                                         desc = "PackageCabal" },
      { "<leader>ms", "<cmd>lua require('haskell-tools').hoogle.hoogle_signature()<CR>", desc = "hoggle signature" },
      buffer = true
    })
  elseif fileType == 'http' then
    which_key.add({
      { "<leader>mr", "<cmd>Rest run<CR>", desc = "PackageCabal" },
      buffer = true
    })
  end
end

vim.cmd('autocmd FileType * lua FileSpecificKeybinding()')
