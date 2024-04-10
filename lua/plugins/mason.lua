return {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "gopls",
      "goimports",
      "golangci-lint",
      "golangci-lint-langserver", -- Wraps golangci-lint as a language server
      "goimports-reviser",
      "delve",
      "mdformat",
      "yaml-language-server",
    })
  end,
}
