local telescope = require("telescope")
local actions = require("telescope.actions")
local fb_actions = require("telescope._extensions.file_browser.actions")
local lga_actions = require("telescope-live-grep-args.actions")


local fzf_opts = {
  -- https://github.com/nvim-telescope/telescope.nvim/issues/2104
  fuzzy = false,                  -- false will only do exact matching
  override_generic_sorter = true, -- override the generic sorter
  override_file_sorter = true,    -- override the file sorter
  -- case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
  case_mode = "ignore_case",      -- or "ignore_case" or "respect_case"
  -- the default case_mode is "smart_case"
}

local function build_size_sensitive_previewer(size)
  local previewers = require("telescope.previewers")
  local putils = require("telescope.previewers.utils")
  local pfiletype = require("plenary.filetype")
  local new_maker = function(filepath, bufnr, opts)
    opts = opts or {}
    if opts.use_ft_detect == nil then
      opts.use_ft_detect = true
    end

    filepath = vim.fn.expand(filepath)
    local ft = pfiletype.detect(filepath, {})
    local ok, stats = pcall(vim.loop.fs_stat, filepath)
    if ok and stats and stats.size > size then
      opts.use_ft_detect = false
      putils.regex_highlighter(bufnr, ft)
    end
    previewers.buffer_previewer_maker(filepath, bufnr, opts)
  end
  return new_maker
end

telescope.setup({
  defaults = {
    -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    preview = {
      timeout = 1000,
      treesitter = false,
    },
    prompt_prefix = " ",
    path_display = { "truncate" },
    -- layout_strategy = 'flex',
    -- layout_config = {
    --   flex = {
    --     prompt_position = "top",
    --   },
    -- },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
      },
    },
    sorting_strategy = "ascending",

    buffer_previewer_maker = build_size_sensitive_previewer(100000),
    mappings = {
      i = {
        -- ["<CR>"] = actions.select_default,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        -- ["<C-n>"] = actions.move_selection_next,
        -- ["<C-p>"] = actions.move_selection_previous,
        -- ["<C-h>"] = actions.which_key,
        -- ["<C-d>"] = actions.close,
        -- ['<C-f>'] = false,
        -- ['<C-b>'] = false,
        -- ['<C-a>'] = false,
        -- ['<C-e>'] = false,
        -- ['<Tab>'] = false,
        -- ['<S-Tab>'] = false,
      },
      n = {
        -- ["q"]      = actions.send_to_qflist + actions.open_qflist,
        ["<C-n>"]  = actions.move_selection_next,
        ["<C-p>"]  = actions.move_selection_previous,
        -- ["<ESC>"]   = actions.close,
        -- ["j"]       = actions.move_selection_next,
        -- ["k"]       = actions.move_selection_previous,
        ["<Down>"] = actions.cycle_history_next,
        ["<Up>"]   = actions.cycle_history_prev,
        -- ["?"]       = actions.which_key,
        -- ["x"]       = function(prompt_bufnr)
        --   actions.toggle_selection(prompt_bufnr)
        --   -- sleep 1s
        --   vim.defer_fn(function()
        --     actions.delete_buffer(prompt_bufnr)
        --   end, 1000)
        --   -- actions.delete_buffer(prompt_bufnr)
        -- end,
        -- ["s"]       = actions.toggle_selection,
        -- ['<S-Tab>'] = false,
      },
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
    },
    lsp_dynamic_workspace_symbols = {
      sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts)
    },
    command_history = {
      mappings = {
        ["i"] = {
          ['<C-f>'] = false,
          ['<C-b>'] = false,
          ['<C-a>'] = false,
          ['<C-e>'] = false,
        },
        ["n"] = {
          ['e'] = actions.edit_command_line,
        },
      },
    },
  },
  extensions = {
    fzf = fzf_opts,
    file_browser = {
      hidden = false,
      no_ignore = true,
      hide_parent_dir = false,
      mappings = {
        ["i"] = {
          ['<C-f>'] = false,
          ['<C-b>'] = false,
          ['<C-a>'] = false,
          ['<C-e>'] = false,
        },
        ["n"] = {
          ["n"] = fb_actions.create,
          ["r"] = fb_actions.rename,
          ["m"] = fb_actions.move,
          ["y"] = fb_actions.copy,
          ["d"] = false,
          ["x"] = fb_actions.remove,
          ["o"] = fb_actions.open,
          ["u"] = fb_actions.goto_parent_dir,
          ["U"] = fb_actions.goto_home_dir,
          ["w"] = fb_actions.goto_cwd,
          ["f"] = fb_actions.toggle_browser,
          ["h"] = fb_actions.toggle_hidden,
          ["T"] = fb_actions.toggle_all,
          -- ["h"] = fb_actions.toggle_gitignore,
        },
      },
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        }
      }
    },
  }
})


telescope.load_extension('fzf')
telescope.load_extension('file_browser')
telescope.load_extension('live_grep_args')
telescope.load_extension("recent_files")
telescope.load_extension('project')
