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
  {
    "<leader>yl",
    function()
      local path = vim.fn.expand("%:p")
      local mode = vim.fn.mode()

      if mode == "v" or mode == "V" then
        local start_line = vim.fn.line("v")
        local end_line   = vim.fn.line(".")
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        vim.fn.setreg("+", string.format("%s:%d-%d", path, start_line, end_line))
      else
        -- normal mode: copy file:path:LINE
        local line = vim.fn.line(".")
        vim.fn.setreg("+", string.format("%s:%d", path, line))
      end
    end,
    mode = { "n", "v" },
    desc = "Copy file path with line or line range",
  },
  { "<leader>yf",     '<cmd>let @+ = expand("%:p")<CR><esc>', desc = "Copy file path", },
  {
    "<leader>yl",
    function()
      local path = vim.fn.expand("%:p")
      local mode = vim.fn.mode()

      if mode == "v" or mode == "V" or mode == "\22" then
        local l1 = vim.fn.line("v")
        local l2 = vim.fn.line(".")
        local start_line = math.min(l1, l2)
        local end_line = math.max(l1, l2)

        if start_line == end_line then
          vim.fn.setreg("+", string.format("%s:%d", path, start_line))
        else
          vim.fn.setreg("+", string.format("%s:%d-%d", path, start_line, end_line))
        end
      else
        local line = vim.fn.line(".")
        vim.fn.setreg("+", string.format("%s:%d", path, line))
      end
    end,
    mode = { "n", "x" },
    desc = "Copy file path with line number",
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
