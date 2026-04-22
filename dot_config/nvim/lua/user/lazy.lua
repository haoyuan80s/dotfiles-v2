-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
  checker = { enabled = false },
  spec = {
    { "folke/tokyonight.nvim" },
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      enabled = true,
      branch = "main",
      dependencies = {
        -- { "github/copilot.vim" },    -- or zbirenbaum/copilot.lua
        { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      build = "make tiktoken",       -- Only on MacOS or Linux
      opts = {
        -- model = 'claude-sonnet-4', -- this is expensive
        model = 'gpt-4.1', -- this is free
      },
    },
    {
      'linrongbin16/lsp-progress.nvim',
      config = function()
        require('lsp-progress').setup()
      end
    },
    "f-person/git-blame.nvim",
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      config = function()
        require('user.snacks')
      end,
    },
    {
      "obsidian-nvim/obsidian.nvim",
      version = "*", -- recommended, use latest release instead of latest commit
      enabled = true,
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      opts = {
        workspaces = {
          {
            name = "notes",
            path = "~/notes",
          },
        },
        ui = { enable = false },
        legacy_commands = false,
        frontmatter = { enabled = false },
        picker = {
          name = "snacks.pick",
        },
        statusline = { enabled = false },
        footer = { enabled = false },
        completion = {
          nvim_cmp = false,
          blink = true,
          min_chars = 1,
          match_case = true,
          create_new = true,
        },
        daily_notes = {
          folder = "Journal",
          workdays_only = false
        },
        attachments = {
          folder = "assets/img",
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      enabled = true,
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
      opts = {
        latex = { enabled = true },
        render_modes = { 'n', 'c', 'i', 'no', 'v', 'V', '', 's' },
        heading = {
          -- Turn on / off heading icon & background rendering
          enabled = true
        },
        bullet = {
          enabled = true
        },
        indent = {
          enabled = false
        },
        checkbox = {
          -- Turn on / off checkbox state rendering
          enabled = true,
          unchecked = {
            -- Replaces '[ ]' of 'task_list_marker_unchecked'
            icon = '󰄱',
            -- Highlight for the unchecked icon
            highlight = 'RenderMarkdownUnchecked',
            -- Highlight for item associated with unchecked checkbox
            scope_highlight = nil,
          },
          checked = {
            -- Replaces '[x]' of 'task_list_marker_checked'
            icon = '',
            -- Highlight for the checked icon
            highlight = 'RenderMarkdownChecked',
            -- Highlight for item associated with checked checkbox
            scope_highlight = nil,
          },
          custom = {
            todo = { raw = '[-]', rendered = '󰥔', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            canceled = { raw = '[#]', rendered = '󰜺', highlight = 'RenderMarkdownError', scope_highlight = nil },
          },
        },
      },
    },
    {
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup(
          {
            stages = "static",
          }
        )
      end
    },
    {
      "folke/which-key.nvim",
      -- priority = 1001, -- this plugin needs to run before anything else
      config = function() require('user.whichkey') end
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },

    {
      'echasnovski/mini.pairs',
      version = false,
      config = function()
        require('mini.pairs').setup()
      end
    },
    {

      'windwp/nvim-ts-autotag',
      config = function()
        require('nvim-ts-autotag').setup({
          opts = {
            enable_close = true,          -- Auto close tags
            enable_rename = true,         -- Auto rename pairs of tags
            enable_close_on_slash = false -- Auto close on trailing </
          },
          per_filetype = {
            ["html"] = {
              enable_close = false
            }
          }
        })
      end

    },
    {
      'echasnovski/mini.operators',
      version = false,
      config = function()
        require('mini.operators').setup(
          {
            multiply = {
              prefix = '',
              func = nil,
            },
            exchange = {
              prefix = 'g<Tab>',
              reindent_linewise = true,
            },
          }
        )
      end
    },
    {
      'echasnovski/mini.icons',
      version = false,
      config = function()
        require('mini.icons').setup()
        MiniIcons.mock_nvim_web_devicons()
      end
    },
    { 'echasnovski/mini.completion', version = false },
    -- {
    --   "norcalli/nvim-colorizer.lua",
    --   config = function()
    --     require 'colorizer'.setup()
    --   end
    -- },
    "stefandtw/quickfix-reflector.vim",
    -- "Decodetalkers/csharpls-extended-lsp.nvim",
    "b0o/schemastore.nvim",
    {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        { 'tpope/vim-dadbod', lazy = true },
        {
          'kristijanhusak/vim-dadbod-completion',
          lazy = true
        },
      },
      cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
      },
      init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    {
      "mfussenegger/nvim-lint"
    },
    {
      'stevearc/conform.nvim',
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
            kotlin = { "ktfmt" },
            toml = { "taplo" },
            xml = { "xmlformatter" },
            json = { "prettier" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            markdown = { "prettier" },
            xml = { "xmlformatter" },
            yaml = { "prettier" },
            proto = { "buf" },
            sql = { "pg_format" },
            swift = { "swiftformat" },
          },
          format_on_save = {
            timeout_ms = 1000,
            lsp_format = "fallback",
          },
        })
      end
    },
    { "nvim-lualine/lualine.nvim", config = function() require("user.lualine") end },
    {
      "j-hui/fidget.nvim",
      enabled = false,
      tag = "v1.0.0",
      config = function()
        require("fidget").setup {}
      end
    },
    {
      "nvimdev/guard.nvim",
      -- Builtin configuration, optional
      dependencies = {
        "nvimdev/guard-collection",
      },
    },
    {
      'numToStr/Comment.nvim',
      -- enabled = false,
      config = function()
        local prehook = require("ts_context_commentstring.integrations.comment_nvim")
            .create_pre_hook()
        require("Comment").setup({

          extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gC',
            -- eol = "gcA",
          },
          padding = true,
          sticky = true,
          ignore = "^$",
          toggler = {
            line = "gcc",
            -- block = "gbc",
            -- block = "gbc",
          },
          opleader = {
            line = "gc",
            -- block = "gb",
            -- block = "gb",
          },
          mappings = {
            basic = true,
            extra = true,
            extended = false,
          },
          pre_hook = prehook,
        })
      end,
      event = "BufReadPre",
      lazy = false,
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
    },

    {
      'saecki/crates.nvim',
      event = { "BufRead Cargo.toml" },
      config = function()
        require('crates').setup({})
      end,
    },
    {
      'timtro/glslView-nvim',
      ft = 'glsl',
      opts = {
        viewer_path = 'glslViewer',
        args = { '-l' },
      }
    },
    -- {
    --   -- "haoyuan80s/xcodebuild.nvim",
    --   "wojciech-kulik/xcodebuild.nvim",
    --   dependencies = {
    --     "nvim-telescope/telescope.nvim",
    --     "MunifTanjim/nui.nvim",
    --   },
    --   config = function()
    --     require("xcodebuild").setup({})
    --   end,
    -- },
    'NoahTheDuke/vim-just',
    {
      "vhyrro/luarocks.nvim",
      enabled = false,
      priority = 1000,
      config = true,
    },
    {
      'saghen/blink.cmp',
      -- dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },

      dependencies = {
        "L3MON4D3/LuaSnip",
        version = 'v2.*',
        config = function()
          require("luasnip").filetype_extend("python", { "python" })
          require("luasnip").filetype_extend("lua", { "lua" })
          require("luasnip").filetype_extend("markdown", { "tex" })
          require("luasnip").filetype_extend("javascriptreact", { "html" })
          require("luasnip").filetype_extend("typescriptreact", { "html" })
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets" } })
        end,
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
          }, -- a bunch of snippets to use
        }
      },
      version = '1.*',
      opts = {
        snippets = { preset = 'luasnip' },
        keymap = {
          ['<C-s>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-c>'] = { 'hide', 'fallback' },
          ['<Tab>'] = {
            function(cmp)
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end,
            'snippet_forward',
            'fallback'
          },
          ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
          ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
          ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-g>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
        appearance = {
          nerd_font_variant = 'mono'
        },
        completion = { documentation = { auto_show = false } },
        cmdline = {
          keymap = {
            ['<Tab>'] = { 'show', 'accept' },
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<Right>'] = false,
            ['<Left>'] = false,
          },
          completion = { menu = { auto_show = true } },
          sources = function()
            local type = vim.fn.getcmdtype()
            if type == '/' or type == '?' then return { 'buffer' } end
            if type == ':' or type == '@' then return { 'cmdline' } end
            return {}
          end,
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          per_filetype = {
            sql = { 'snippets', 'dadbod', 'buffer' },
          },
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            snippets = {
              override = {
                get_trigger_characters = function(_)
                  return { "#", "\\" }
                end,
              },
            },
            lsp = {
              name      = "LSP",
              module    = "blink.cmp.sources.lsp",
              fallbacks = {}, -- always show buffer
            },
          }
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
      "kawre/leetcode.nvim",
      dependencies = {
        -- include a picker of your choice, see picker section for more details
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
      },
      opts = {
        lang = "python",
      },
    },
    {
      'mrcjkb/rustaceanvim',
      version = '^7', -- Recommended
      lazy = false,   -- This plugin is already lazy
    },
    {
      "neovim/nvim-lspconfig",
      inlay_hints = { enabled = true },
      config = function()
        require("user.lsp.lsp")
      end,
      dependencies = {
        { "williamboman/mason.nvim" },
      }
    },
    {
      "mason-org/mason.nvim",
      opts = {}
    },
    "imsnif/kdl.vim",
    {
      'kevinhwang91/nvim-ufo',
      dependencies = 'kevinhwang91/promise-async',
      config = function()
        require('ufo').setup({
          provider_selector = function(bufnr, filetype, buftype)
            return { 'treesitter', 'indent' }
          end
        })
      end
    },
    {
      'smoka7/hop.nvim',
      version = '*',
      opts = {
        keys = 'etovxqpdygfblzhckisuran',
      },
    },
    { "tpope/vim-sensible" },
    {
      'tummetott/unimpaired.nvim',
      event = 'VeryLazy',
      config = function()
        require('user.unimpaired')
      end
    },
    { 'sindrets/diffview.nvim' },
    { "ludovicchabant/vim-gutentags", enabled = false },

    -- basic
    { "dstein64/vim-startuptime",     enabled = false },
    {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end
    },
    "tpope/vim-repeat",
    "farmergreg/vim-lastplace",
    "bfredl/nvim-luadev",
    "folke/neodev.nvim",
    { 'ray-x/guihua.lua',             e = false }, -- recommended if need floating window support
    {
      "github/copilot.vim",
      enabled = true,
      init = function()
        vim.g.copilot_enabled = false
        vim.g.copilot_no_tab_map = true
        -- vim.g.copilot_settings = { selectedCompletionModel = "gpt-41-copilot" }
        vim.g.copilot_integration_id = "vscode-chat"
        vim.api.nvim_create_user_command('ToggleCopilot', function()
          vim.g.copilot_enabled = not vim.g.copilot_enabled
          print('Copilot is ' .. (vim.g.copilot_enabled and 'enabled' or 'disabled'))
        end, {})
      end,
      config = function()
        require("user.copilot")
      end,
    },
    {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        { 'tpope/vim-dadbod',                     ft = { 'sql', 'mysql', 'plsql', 'sqlite' }, lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'sqlite' }, lazy = true },
      },
      cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
      },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup {
          on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']h', function()
              if vim.wo.diff then
                vim.cmd.normal({ ']h', bang = true })
              else
                gitsigns.nav_hunk('next')
              end
            end, { desc = "next git hunk" })

            map('n', '[h', function()
              if vim.wo.diff then
                vim.cmd.normal({ '[h', bang = true })
              else
                gitsigns.nav_hunk('prev')
              end
            end, { desc = "prev git hunk" })
          end
        }
      end
    },
    { "machakann/vim-highlightedyank" },
    { "mbbill/undotree",              cmd = { "UndotreeToggle" } },
    {
      "stevearc/aerial.nvim",
      enabled = true,
      config = function()
        require('aerial').setup(
          {
            backends = { "treesitter", "markdown", "asciidoc", "man" },
          }
        )
      end
    },
    { "kylelaker/riscv.vim",        e = false },
    -- {
    --   "HiPhish/rainbow-delimiters.nvim",
    --   config =
    --       function()
    --         require('rainbow-delimiters.setup').setup {
    --           strategy = {
    --             [''] = require('rainbow-delimiters').strategy['global'],
    --             vim = require('rainbow-delimiters').strategy['local'],
    --           },
    --           query = {
    --             [''] = 'rainbow-delimiters',
    --             lua = 'rainbow-blocks',
    --           },
    --           priority = {
    --             [''] = 110,
    --             lua = 210,
    --           },
    --           highlight = {
    --             'RainbowDelimiterRed',
    --             'RainbowDelimiterYellow',
    --             'RainbowDelimiterBlue',
    --             'RainbowDelimiterOrange',
    --             'RainbowDelimiterGreen',
    --             'RainbowDelimiterViolet',
    --             'RainbowDelimiterCyan',
    --           },
    --         }
    --       end
    -- },

    -- {
    --   'brenoprata10/nvim-highlight-colors',
    --   config = function()
    --     require('nvim-highlight-colors').setup {}
    --   end
    -- },
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    -- "kyazdani42/nvim-web-devicons",
    -- {
    --   -- https://github.com/mg979/vim-visual-multi
    --   "mg979/vim-visual-multi",
    --   -- init = function()
    --   --   vim.g.VM_set_statusline = 0
    --   --   vim.g.VM_add_cursor_at_pos_no_mappings = 1
    --   --   vim.g.VM_leader = '\\'
    --   --   vim.g.VM_maps = {
    --   --     ["Find Under"]    = "<C-d>",
    --   --     ["Find Prev"]     = "<C-p>",
    --   --     ["Find Next"]     = "<C-n>",
    --   --     ['Select All']    = '<C-Down>',
    --   --     ['Add Cursor Up'] = '<C-Up>',
    --   --   }
    --   -- end,
    --   --
    --   -- lazy = false,
    --   -- branch = "master"
    -- },
    -- {
    --   'goolord/alpha-nvim',
    --   -- dependencies = { 'kyazdani42/nvim-web-devicons' },
    --   config = function()
    --     require 'alpha'.setup(require 'alpha.themes.startify'.config)
    --     -- require 'alpha'.setup(require 'alpha.themes.theta'.config)
    --     -- require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    --   end
    -- },
    {
      'Julian/lean.nvim',
      e = true,
      event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

      dependencies = {
        'nvim-lua/plenary.nvim',

        -- optional dependencies:

        -- a completion engine
        --    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

        -- 'nvim-telescope/telescope.nvim', -- for 2 Lean-specific pickers
        -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
        -- 'andrewradev/switch.vim',        -- for switch support
        -- 'tomtom/tcomment_vim',           -- for commenting
      },

      ---@type lean.Config
      opts = { -- see below for full configuration options
        mappings = true,
      }
    },

    { "p00f/clangd_extensions.nvim" },
    { 'ray-x/go.nvim',              e = false },
    { 'ShinKage/idris2-nvim',       e = false },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        local ts = require("nvim-treesitter")
        ts.setup()
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function() require("user.nvim-treesitter-textobjects") end,
    }
  }
})
