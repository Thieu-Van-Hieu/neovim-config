return {
  "pio",
  dir = vim.fn.stdpath("config") .. "/my-plugins/pio.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = true,
}
