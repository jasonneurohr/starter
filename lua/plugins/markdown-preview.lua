return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    {
      "<leader>cp",
      -- ft = "markdown", -- breaks stuff :(
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  -- this doesn't seem to work
  -- instead directly patch .local/share/nvim/lazy/markdown-preview.nvim/app/out
  -- replace the mermaid local with https://www.jsdelivr.com/package/npm/mermaid
  -- refresh seems to default back to old version
  -- instead of this replace the js in _static instead
  config = function()
    --   vim.g.mkdp_preview_options = {
    --     mermaid = {
    --       enable = 0,
    --       theme = "default",
    --       -- override the version via CDN
    --       mermaid_js_path = "https://cdn.jsdelivr.net/npm/mermaid@11.6.0/+esm",
    --     },
    --   }
    vim.cmd([[do FileType]])
  end,
}
