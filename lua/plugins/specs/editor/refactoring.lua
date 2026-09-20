return {
  "ThePrimeagen/refactoring.nvim",
  lazy = false, -- Load ngay, không chờ lazy-load từ extras
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "lewis6991/async.nvim", -- phụ thuộc vào async.nvim ở trên
  },
  config = function()
    -- chờ async chắc chắn
    local ok, async = pcall(require, "async")
    if not ok then
      vim.notify("refactoring.nvim không tìm thấy async", vim.log.levels.ERROR)
      return
    end
    require("refactoring").setup()
  end,
}
