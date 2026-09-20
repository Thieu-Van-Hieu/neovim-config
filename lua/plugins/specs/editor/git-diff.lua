return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      -- Mở giao diện so sánh toàn bộ project (giống Git Merge Tool của IntelliJ)
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },

      -- Đóng Diffview và quay lại giao diện code bình thường
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },

      -- Xem lịch sử thay đổi của chính file đang mở (rất hữu ích)
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (Current File)" },
    },
    opts = {
      enhanced_diff_hl = true, -- Highlight chi tiết thay đổi từng từ trong dòng
      view = {
        -- Cấu hình layout 3 cột khi xử lý conflict
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true, -- Tắt báo lỗi LSP khi đang giải quyết conflict cho đỡ rối
        },
      },
    },
  },
}
