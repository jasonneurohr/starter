return {
  "folke/tokyonight.nvim",
  lazy = true,
  opts = {
    style = "moon",
    on_colors = function(colors)
      colors.comment = colors.orange
    end,
    on_highlights = function(highlights, colors)
      highlights.LineNrAbove = { fg = "#51B3EC", bold = true }
      highlights.LineNr = { fg = "#FFFFFF", bold = true }
      highlights.CursorLineNr = { fg = "#FFFFFF", bold = true }
      highlights.LineNrBelow = { fg = "#FB508F", bold = true }
    end,
  },
}
