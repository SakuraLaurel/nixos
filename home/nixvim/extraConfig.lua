vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = {
      border = "rounded",
      source = "if_many",
  },
})

-- 让 Copilot ghost text 在 blink.cmp 菜单打开时隐藏，避免视觉冲突。
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})
