-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Paste from clipboard and strip Windows newlines (\r)
vim.keymap.set("n", "<leader>p", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! "+p')
  vim.cmd([[silent! '[,']s/\r//g]])
  vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Paste (clean Windows newlines)" })

vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Open Oil file browser" })

vim.keymap.set("n", "<leader>h", Snacks.dashboard.open, { desc = "Open starter screen" })
