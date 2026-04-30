require('mason').setup({})

vim.lsp.enable('taplo')
vim.lsp.enable('basedpyright')
vim.lsp.enable('ts_ls')
vim.lsp.config('basedpyright',
  {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true, -- on mac File Watcher are turn-oned by default (LspInfo)
        },
      },
    },
  }
)

vim.lsp.enable('clangd')
vim.lsp.config('lua_ls', {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, {
      '.git',
      '.luarc.json',
      '.luarc.jsonc',
      '.luacheckrc',
      'stylua.toml',
      'selene.toml',
      'init.lua',
    })

    if root and root ~= vim.env.HOME then
      on_dir(root)
      return
    end

    -- Refuse to start for files outside a real project root
    on_dir(nil)
  end,
})
vim.lsp.enable('lua_ls')

-- vim.lsp.enable("sourcekit")
-- vim.lsp.config("sourcekit", {
--   root_dir = function(_, callback)
--     callback(
--       require("lspconfig.util").root_pattern("Package.swift")(vim.fn.getcwd())
--       or require("lspconfig.util").find_git_ancestor(vim.fn.getcwd())
--     )
--   end,
--   cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) }
-- })

-- vim.lsp.enable('rust_analyzer')
-- vim.lsp.config('rust_analyzer', {
--   settings = {
--     ['rust-analyzer'] = {
--       imports = {
--         granularity = {
--           group = "item",
--         },
--         merge = {
--           glob = false,
--         }
--       },
--       cargo = {
--         features = "all",
--       },
--       procMacro = {
--         ignored = {
--           leptos_macro = {
--             -- optional: --
--             -- "component",
--             "server",
--           },
--         },
--       },
--     }
--   }
-- })

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          target = "aarch64-apple-ios",
        },
        check = {
          command = "check",
          targets = { "aarch64-apple-ios" },
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
}

-- vim.g.rustaceanvim = {
--   server = {
--     capabilities = {
--       textDocument = {
--         completion = { completionItem = { insertReplaceSupport = true } },
--       },
--     },
--     default_settings = {
--       ['rust-analyzer'] = {
--         files = {
--           watcher = 'client',
--         },
--         imports = {
--           granularity = {
--             group = "item",
--           },
--           merge = {
--             glob = false,
--           }
--         },
--         cargo = {
--           features = "all",
--         },
--         -- for ignoring the macro-error warning using spacta in the shadow run projects
--         -- diagnostics = {
--         --   disabled = { "macro-error", "unresolved-proc-macro" },
--         -- },
--         procMacro = {
--           -- ignored = {
--           --   leptos_macro = {
--           --     -- optional: --
--           --     -- "component",
--           --     "server",
--           --   },
--           -- },
--         },
--       },
--     },
--   },
-- }

-- vim.lsp.enable("yamlls")
vim.lsp.enable("jsonls", {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})
vim.lsp.enable('tailwindcss')
vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls',
  {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true, -- on mac File Watcher are turn-oned by default (LspInfo)
        },
      },
    },
  }
)
-- vim.lsp.enable('yamlls', {
--   settings = {
--     yaml = {
--       schemaStore = {
--         -- You must disable built-in schemaStore support if you want to use
--         -- this plugin and its advanced options like `ignore`.
--         enable = false,
--         -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
--         url = "",
--       },
--       schemas = require('schemastore').yaml.schemas(),
--     },
--   },
-- })

vim.diagnostic.config({
  float = {
    border = "rounded", -- "single", "double", "shadow", "rounded"
    source = "if_many",
    focusable = true,
  },
})

local Snacks = require("snacks")
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    vim.lsp.log.set_level("OFF")
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover({border = 'rounded'})<CR>", { buffer = true })
    require("which-key").add {
      { "gd",  function() Snacks.picker.lsp_definitions() end,                                                                    desc = "Go to Definition" },
      { "gD",  function() Snacks.picker.lsp_references() end,                                                                     desc = "Go to References" },
      { "gld", function() Snacks.picker.lsp_declarations() end,                                                                   desc = "Go to Declaration" },
      { "gli", function() Snacks.picker.lsp_implementations() end,                                                                desc = "Go to Implementation" },
      { "glt", function() Snacks.picker.lsp_type_definitions() end,                                                               desc = "Go to Type Definition" },
      -- Optional group label
      { "gl",  group = "LSP" },
      { "[d",  '<cmd>lua vim.diagnostic.jump({count= -1,float = true})<CR>',                                                      desc = "Previous Diagnostic" },
      { "]d",  '<cmd>lua vim.diagnostic.jump({count= 1,float = true})<CR>',                                                       desc = "Next Diagnostic" },
      { "[e",  '<cmd>lua vim.diagnostic.jump({count= -1,float = true, severity = { min = vim.diagnostic.severity.ERROR } })<cr>', desc = "Previous Diagnostic" },
      { "]e",  '<cmd>lua vim.diagnostic.jump({count= 1, float = true, severity = { min = vim.diagnostic.severity.ERROR } })<cr>', desc = "Next Diagnostic" },
      buffer = true
    }
  end
})


local virtual_text_enabled = true
function ToggleVirtualText()
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.config({
    virtual_text = virtual_text_enabled,
    underline = false,
    float = { border = 'none' },
  })
end

require('lint').linters_by_ft = {
  proto = { "buf_lint" },
}

-- for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
--   local default_diagnostic_handler = vim.lsp.handlers[method]
--   vim.lsp.handlers[method] = function(err, result, context, config)
--     if err ~= nil and err.code == -32802 then
--       return
--     end
--     return default_diagnostic_handler(err, result, context, config)
--   end
-- end
