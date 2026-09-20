-- Sử dụng Zsh làm shell mặc định cho Neovim
vim.opt.shell = "zsh"

-- Cấu hình cờ lệnh cho Zsh (-c để thực thi lệnh chuỗi)
vim.opt.shellcmdflag = "-c"

-- Xóa các cấu hình quote đặc thù của Windows/PowerShell về mặc định
vim.opt.shellquote = ""
vim.opt.shellxquote = ""

-- Cấu hình luồng xuất dữ liệu (redirection) theo chuẩn POSIX/Linux
vim.opt.shellredir = ">%s 2>&1"
