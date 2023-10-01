local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim",                          import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.lang.json" },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc", "terraform", "hcl" })
        end
      end,
    },

    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    --

    {
      import = "lazyvim.plugins.extras.coding.copilot",
      enabled = false, -- Disabled for now
      opts = {
        suggestion = { enabled = true },
        panel = { enabled = true },
        filetypes = {
          markdown = true,
          help = true,
        },
      },
    },
    {
      import = "lazyvim.plugins.extras.lang.go",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "go",
          "gomod",
          "gowork",
          "gosum",
        })
      end,
    },
    -- adapted from here https://github.com/bjartek/dotfiles/blob/master/.config/lazyvim/lua/plugins/go.lua
    {
      "ray-x/go.nvim",
      dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.go" },
          callback = function()
            local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding(0))
            params.context = { only = { "source.organizeImports" } }

            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            for _, res in pairs(result or {}) do
              for _, r in pairs(res.result or {}) do
                if r.edit then
                  vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding(0))
                else
                  vim.lsp.buf.execute_command(r.command)
                end
              end
            end
          end,
        })
      end,
      event = "CmdlineEnter",
      ft = { "go", "gomod", "gosum", "gowork" },
    },
    -- mason
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          "gopls",
          "goimports",
          "golangci-lint",
          "golangci-lint-langserver", -- Wraps golangci-lint as a language server
          "goimports-reviser",
          "delve",
        })
      end,
    },
    -- end adaption from https://github.com/bjartek/dotfiles/blob/master/.config/lazyvim/lua/plugins/go.lua
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          terraformls = {},
          gopls = {
            keys = {
              -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
              { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
            },
            settings = {
              gopls = {
                gofumpt = true,
                codelenses = {
                  gc_details = false,
                  generate = true,
                  regenerate_cgo = true,
                  run_govulncheck = true,
                  test = true,
                  tidy = true,
                  upgrade_dependency = true,
                  vendor = true,
                },
                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
                analyses = {
                  fieldalignment = true,
                  nilness = true,
                  unusedparams = true,
                  unusedwrite = true,
                  useany = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
              },
            },
          },
        },
        setup = {
          gopls = function(_, opts)
            -- workaround for gopls not supporting semanticTokensProvider
            -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
            require("lazyvim.util").on_attach(function(client, _)
              if client.name == "gopls" then
                if not client.server_capabilities.semanticTokensProvider then
                  local semantic = client.config.capabilities.textDocument.semanticTokens
                  client.server_capabilities.semanticTokensProvider = {
                    full = true,
                    legend = {
                      tokenTypes = semantic.tokenTypes,
                      tokenModifiers = semantic.tokenModifiers,
                    },
                    range = true,
                  }
                end
              end
            end)
            -- end workaround
          end,
        },
      },
    },
    { import = "lazyvim.plugins.extras.lang.json" },
    {
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#arguments
      -- https://www.mankier.com/1/shfmt
      -- "jose-elias-alvarez/null-ls.nvim",
      "nvimtools/none-ls.nvim",
      opts = function()
        local nls = require("null-ls")
        return {
          sources = {
            nls.builtins.formatting.shfmt.with({
              extra_args = { "-i", "2", "-ci" },
            }),
          },
        }
      end,
      -- dependencies = {
      --   {
      --     "jay-babu/mason-null-ls.nvim",
      --     cmd = { "NullLsInstall", "NullLsUninstall" },
      --     opts = { handlers = {} },
      --   },
      -- },
      -- event = "User BaseFile",
      -- opts = function()
      --   local nls = require("null-ls")
      --   return {
      --     sources = {
      --       nls.builtins.formatting.beautysh.with({
      --         command = "beautysh",
      --         args = {
      --           "--indent-size",
      --           "2",
      --           "$FILENAME",
      --         },
      --       }),
      --     },
      --     on_attach = require("base.utils.lsp").on_attach, -- breaks it
      --   }
      -- end,
    },
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
