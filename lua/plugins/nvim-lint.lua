local lint = require("lint")

lint.linters.mycustomlinter = {
  --error("WELL HELLO THERE 1"),
  cmd = "hook-config-control-name",
  -- Define the command as a function that receives the buffer number
  -- cmd = function(bufnr)
  --   -- Retrieve the full path of the current file from the buffer number
  --   -- local path = vim.fn.expand("%") -- gives the full path
  --   local path = vim.fn.expand("%:p") -- abosolute path
  --   -- local path = vim.api.nvim_buf_get_name(bufnr)
  --   if path == nil or path == "" then
  --     return nil -- If there's no valid path, return nil to avoid running the linter
  --   end
  --   -- Construct the command with the path as an argument
  --   return { "hook-config-control-name", "--lint", "--path", path }
  -- end,
  stdin = true,
  stream = "both",
  args = {},
  --args = { "--lint" },
  --args = {},
  ignore_exitcode = false,
  -- parser = lint.parser_from_pattern(
  --   -- Example pattern: filename:line:col:severity:message
  --   "(.*):(%d+):(%d+):(%w+):(.*)",
  --   { "file", "line", "col", "severity", "message" },
  --   nil,
  --   {
  --     ["source"] = "mycustomlinter",
  --     ["severity_map"] = {
  --       error = vim.diagnostic.severity.ERROR,
  --       warning = vim.diagnostic.severity.WARN,
  --     },
  --   }
  -- ),
  parser = function(output, bufnr)
    --error("WELL HELLO THERE 2")
    local diagnostics = {}
    for _, line in ipairs(vim.split(output, "\n")) do
      local file, lnum, col, severity, message = line:match("(.*):(%d+):(%d+):(%w+):(.*)")
      if lnum then
        table.insert(diagnostics, {
          bufnr = bufnr,
          lnum = tonumber(lnum) - 1,
          col = tonumber(col) - 1,
          severity = vim.diagnostic.severity[severity:upper()],
          message = message,
          source = "mylint",
        })
      end
    end
    --error("WELL HELLO THERE 3")
    return diagnostics
  end,
}

lint.linters.mycustomlinterfilemode = {
  --error("WELL HELLO THERE 1"),
  cmd = "hook-config-control-name",
  -- Define the command as a function that receives the buffer number
  -- cmd = function(bufnr)
  --   -- Retrieve the full path of the current file from the buffer number
  --   -- local path = vim.fn.expand("%") -- gives the full path
  --   local path = vim.fn.expand("%:p") -- abosolute path
  --   -- local path = vim.api.nvim_buf_get_name(bufnr)
  --   if path == nil or path == "" then
  --     return nil -- If there's no valid path, return nil to avoid running the linter
  --   end
  --   -- Construct the command with the path as an argument
  --   return { "hook-config-control-name", "--lint", "--path", path }
  -- end,
  stdin = true,
  stream = "both",
  args = { "-f" },
  --args = {},
  ignore_exitcode = false,
  -- parser = lint.parser_from_pattern(
  --   -- Example pattern: filename:line:col:severity:message
  --   "(.*):(%d+):(%d+):(%w+):(.*)",
  --   { "file", "line", "col", "severity", "message" },
  --   nil,
  --   {
  --     ["source"] = "mycustomlinter",
  --     ["severity_map"] = {
  --       error = vim.diagnostic.severity.ERROR,
  --       warning = vim.diagnostic.severity.WARN,
  --     },
  --   }
  -- ),
  parser = function(output, bufnr)
    --error("WELL HELLO THERE 2")
    local diagnostics = {}
    for _, line in ipairs(vim.split(output, "\n")) do
      local file, lnum, col, severity, message = line:match("(.*):(%d+):(%d+):(%w+):(.*)")
      if lnum then
        table.insert(diagnostics, {
          bufnr = bufnr,
          lnum = tonumber(lnum) - 1,
          col = tonumber(col) - 1,
          severity = vim.diagnostic.severity[severity:upper()],
          message = message,
          source = "mylint2",
        })
      end
    end
    --error("WELL HELLO THERE 3")
    return diagnostics
  end,
}

return {
  "mfussenegger/nvim-lint",
  enabled = true,
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      yaml = { "yamllint", "actionlint", "mycustomlinter", "mycustomlinterfilemode" },
    },
    linters = {
      actionlint = {
        condition = function(ctx)
          return string.match(ctx.filename, "/workflows/")
        end,
      },
      mycustomlinter = {
        condition = function(ctx)
          return not string.match(ctx.filename, "kustomization.ya?ml$")
        end,
      },
    },
  },
}
