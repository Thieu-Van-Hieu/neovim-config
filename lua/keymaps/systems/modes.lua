-- Back to normal mode
vim.keymap.set({ "i", "v", "c" }, "<c-l>", "<esc>", { desc = "Back to normal mode in insert, visual, command mode" })
vim.keymap.set("t", "<c-l>", "<C-\\><C-n>", { desc = "Back to normal mode in terminal mode" })
