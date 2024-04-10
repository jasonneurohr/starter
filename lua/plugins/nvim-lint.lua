return {
  "mfussenegger/nvim-lint",
  enabled = true,
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      yaml = { "yamllint", "actionlint" },
    },
    linters = {
      actionlint = {
        condition = function(ctx)
          return string.match(ctx.filename, "/workflows/")
        end,
      },
    },
  },
}
