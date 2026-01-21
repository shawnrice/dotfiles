-- Don't copy on delete
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
-- vim.keymap.set('n', '<leader>d', '"+d', { noremap = true })
-- vim.keymap.set('v', '<leader>d', '"+d', { noremap = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("n", "]<Space>", "o<Esc>", { desc = "Add a blank line below" })
vim.keymap.set("n", "[<Space>", "O<Esc>", { desc = "Add a blank line above" })
