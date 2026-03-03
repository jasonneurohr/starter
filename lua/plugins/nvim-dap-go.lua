return {
  "leoluz/nvim-dap-go",
  config = function()
    require("dap-go").setup({
      -- Additional dap configurations
      dap_configurations = {
        {
          type = "go",
          name = "my Debug",
          request = "launch",
          mode = "test",
          program = "${fileDirname}",
          cwd = "${fileDirname}",
          buildFlags = "--gcflags=all=-N",
        },
      },
    })
  end,
}
