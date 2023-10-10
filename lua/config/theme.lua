local M = {}
function M.LineNumberColors()
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#51B3EC', bold = true })
  vim.api.nvim_set_hl(0, 'LineNr', { fg = '#FFFFFF', bold = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#FFFFFF', bold = true })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#FB508F', bold = true })
end

return M
