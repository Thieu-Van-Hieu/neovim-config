-- Neovim
-- vim.keymap.set("n", "gyy", '"+yy', { desc = "Yank line to system clipboard" })
-- vim.keymap.set("n", "gdd", '"+dd', { desc = "Delete line to system clipboard" })
vim.keymap.set("v", "gy", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("v", "gd", '"+d', { desc = "Delete selection to system clipboard" })

-- Default system
vim.keymap.set("n", "<c-c>", '"+yy', { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<c-x>", '"+dd', { desc = "Delete line to system clipboard" })
vim.keymap.set("v", "<c-c>", '"+y', { desc = "Yank selection to system clipboard" })
vim.keymap.set("v", "<c-x>", '"+d', { desc = "Delete selection to system clipboard" })
