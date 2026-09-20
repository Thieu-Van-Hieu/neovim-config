return {
  -- 1. Tắt mini.pairs
  { "nvim-mini/mini.pairs", enabled = false },

  -- 2. Cấu hình nvim-autopairs kết hợp với Treesitter
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- Quan trọng: Dùng treesitter để check context
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
    config = true,
  },
}
