local o = vim.opt
local g = vim.g

o.clipboard = "unnamedplus"               -- Enable access to System Clipboard
o.updatetime = 500
o.shada = "!,'2000,<100,s10,h"            -- file history setting
-- o.cmdheight = 1 -- space in the neovim command line for displaying messages
o.completeopt = { "menuone", "noselect" } -- mostly just for cmp
o.conceallevel = 0                        -- so that `` is visible in markdown files
o.fileencoding = "utf-8"                  -- the encoding written to a file
o.hlsearch = true                         -- highlight all matches on previous search pattern
o.ignorecase = true                       -- ignore case in search patterns
o.mouse = "a"                             -- allow the mouse to be used in neovim
-- o.mouse = ""                              -- allow the mouse to be used in neovim
o.pumheight = 10                          -- pop up menu height
o.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
o.showtabline = 1
o.smartcase = true                        -- smart case
-- o.smartindent = true -- make indenting smarter again
o.splitbelow = true                       -- force all horizontal splits to go below current window
o.splitright = true                       -- force all vertical splits to go to the right of current window
o.swapfile = false                        -- creates a swapfile
o.termguicolors = true                    -- set term gui colors (most terminals support this)
o.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
o.ttimeoutlen = 0                         -- keyboard sequence timeout (keycode)
o.undofile = true                         -- enable persistent undo
o.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
o.expandtab = true                        -- convert tabs to spaces
o.shiftwidth = 2                          -- the number of spaces inserted for each indentation
o.tabstop = 2                             -- insert 2 spaces for a tab
o.cursorline = true                       -- highlight the current line
o.number = true                           -- set numbered lines
o.relativenumber = true                   -- set relative numbered lines
o.numberwidth = 4                         -- set number column width to 2 {default 4}
o.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
o.guifont = "Hack Nerd Font:h20"          -- the font used in graphical neovim applications
o.wildmenu = true
o.wildmode = "longest:full,full"
-- o.skip_defaults_vim = 1
o.spell = false -- Disable spell checking globally
o.spelllang = o.spelllang + "cjk"
o.spellcapcheck = ""

o.shortmess:append("cSs")
o.whichwrap:append("<,>,[,],h,l")
o.iskeyword:append("-")
o.autochdir = true
o.guicursor = "n-v-sm:block,i-ci-c-ve:ver25,r-cr-o:hor20"

vim.opt.wrap = false -- enable wrapping
vim.opt.linebreak = true -- wrap at word boundaries, not in the middle of a word
vim.opt.breakindent = true -- preserve indentation on wrapped lines
vim.opt.showbreak = "↳ " -- prefix for wrapped lines

-- -- https://github.com/nvim-orgmode/orgmode?tab=readme-ov-file#links-are-not-concealed
-- vim.opt.conceallevel = 2
-- vim.opt.concealcursor = 'nc'
-- g.db_ui_save_location = '~/.config/db_ui'
g.db_ui_use_nerd_fonts = 1
g.highlightedyank_highlight_duration = 100
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.mkdp_auto_close = 0
g.python3_host_prog = '~/.pyenv/shims/python'

g.oscyank_term = 'default'
g.gitblame_enabled = 0

g.gutentags_enabled = 0
g.gutentags_project_root = { 'Makefile', ".git" }
g.gutentags_cache_dir = '~/.cache/tags'
g.gutentags_auto_add_gtags_cscope = 1
g.gutentags_ctags_executable = '/opt/homebrew/bin/ctags'

g.omni_sql_no_default_maps = 1
g.undotree_WindowLayout = 3
g.db_ui_env_variable_url = 'DATABASE_URL'
g.qf_modifiable = 1
g.nvim_tree_respect_buf_cwd = 1

g.mkdp_combine_preview = 1

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- vim.o.foldenable = true
-- vim.o.foldlevel = 99
-- -- vim.o.foldmethod = "expr"
-- -- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- -- vim.o.foldtext = ""
-- vim.opt.foldcolumn = "0"
-- -- vim.opt.fillchars:append({ fold = " " })
-- --
-- --
