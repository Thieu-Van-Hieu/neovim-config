-- Chế độ server (NVIM_LITE=1): tắt plugin và tool chỉ dùng trên máy cá nhân.
-- File này nằm sau LazyVim extras nên các opts function ở đây chạy sau cùng.
local lite = vim.g.lite

return {
  -- Copilot cần Node 22+ (server có Node 20)
  { "zbirenbaum/copilot.lua", enabled = not lite },
  -- Cần CLI claude và UI máy cá nhân
  { "coder/claudecode.nvim", enabled = not lite },
  -- Cần flutter / platformio / trình duyệt
  { "nvim-flutter/flutter-tools.nvim", enabled = not lite },
  { "iamcco/markdown-preview.nvim", enabled = not lite },
  { "pio", enabled = not lite },
  -- Dadbod (từ extra lang.sql)
  { "tpope/vim-dadbod", enabled = not lite },
  { "kristijanhusak/vim-dadbod-ui", enabled = not lite },
  { "kristijanhusak/vim-dadbod-completion", enabled = not lite },

  -- Không tự cài tool qua Mason (sqls cần Go, server không có)
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      if lite then
        opts.ensure_installed = {}
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      if lite then
        opts.ensure_installed = {}
        opts.automatic_installation = false
      end
    end,
  },
  -- LazyVim tự cài qua Mason mọi server trong lspconfig.servers: bỏ sqls khi lite
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if lite and opts.servers then
        opts.servers.sqls = nil
      end
    end,
  },
}
