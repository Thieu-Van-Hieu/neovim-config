return {
  -- 1. Plugin hiển thị màu sắc (Cần thiết để thấy màu)
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "background", -- Hiển thị màu nền dưới mã màu
      enable_named_colors = true,
      enable_tailwind = false, -- Tắt nếu không dùng tailwind để nhẹ máy
    },
  },

  -- 2. Cấu hình Flutter Tools
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Optional: giúp UI chọn device đẹp hơn
    },
    opts = {
      dev_log = {
        enabled = true,
        open_cmd = "tabedit",
      },
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "Comment", -- Nên dùng 'Comment' thay vì 'ErrorMsg' để đỡ chói mắt
        prefix = "// ",
        enabled = true,
      },
      -- CẤU HÌNH QUAN TRỌNG CHO COLOR PREVIEW:
      lsp = {
        color_indicator = {
          enabled = true,
          comment_style = true, -- Hiển thị màu ở phần comment sau dòng code
        },
        -- Đảm bảo settings của dart lsp được truyền vào
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
      hot_reload_on_save = true,
    },
  },
}
