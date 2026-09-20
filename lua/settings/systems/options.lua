-- Disable netrw (dùng file explorer khác như nvim-tree, neo-tree)
vim.g.loaded_netrw = nil
vim.g.loaded_netrwPlugin = nil

vim.opt.backup = false
vim.opt.conceallevel = 0
vim.opt.fileencoding = "utf-8"
vim.cmd("language vi_VN")
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeoutlen = 1000
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.writebackup = false
vim.opt.wrap = true
