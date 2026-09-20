return {
  {
    "stevearc/overseer.nvim",
    opts = {},
    -- Ghi đè và loại bỏ các keymap mặc định của LazyVim
    keys = {
      -- 6 keymap bạn muốn giữ:
      { "<leader>o", desc = "Overseer" }, -- Nhóm chính cho Overseer
      { "<leader>oo", "<cmd>OverseerOpen<cr>", desc = "Open" },
      { "<leader>oc", "<cmd>OverseerClose<cr>", desc = "Close" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run" },
      { "<leader>os", "<cmd>OverseerShell<cr>", desc = "Shell" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },

      -- Vô hiệu hóa các keymap khác có trong ảnh của bạn:
      { "<leader>oi", false }, -- Tắt Overseer Info (i)
      { "<leader>ob", false }, -- Tắt Task builder (b)
      { "<leader>oq", false }, -- Tắt Action recent task (q) / Quickfix
      { "<leader>ow", false }, -- Tắt Task list (W) / Toggle window
      { "<leader>oW", false }, -- Đảm bảo tắt cả chữ hoa nếu có
      { "<leader>oA", false }, -- Đảm bảo tắt cả chữ hoa nếu có
    },
    -- Vẫn giữ init function để phòng trường hợp có conflict khác
    init = function()
      vim.g.lazyvim_overseer_keys = {}
    end,
  },
}
