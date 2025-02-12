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
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    },

    { import = "lazyvim.plugins.extras.lang.json" },
    {
      import = "lazyvim.plugins.extras.ai.copilot",
      enabled = true, -- Enabled
      opts = {
        suggestion = {
          enabled = true,
          auto_trigger = true, -- use next/pre keywords to trigger suggestion instead
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          layout = {
            pos = "bottom",
            ratio = 0.4,
          },
        },
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
    -- end adaption from https://github.com/bjartek/dotfiles/blob/master/.config/lazyvim/lua/plugins/go.lua
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
