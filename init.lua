-- Chế độ server: NVIM_LITE=1 (xem README)
vim.g.lite = vim.env.NVIM_LITE == "1"
-- Lite: dùng danh sách extras riêng (không có lang.*, eslint, prettier)
if vim.g.lite then
  vim.g.lazyvim_json = vim.fn.stdpath("config") .. "/lazyvim.lite.json"
end

-- Đang mở qua SSH: copy qua OSC52 để tới clipboard của máy bạn
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

require("config.lazy")
