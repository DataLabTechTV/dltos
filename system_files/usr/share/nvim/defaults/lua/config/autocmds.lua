-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Dual syntax highlight
vim.filetype.add({
  pattern = {
    [".*%.fish.tmpl"] = "fish.jinja",
  },
})

-- Disable format on save for tmpl
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*.tmpl",
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Set fish indentation to 4 spaces explicitly
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fish", "fish.jinja" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})
