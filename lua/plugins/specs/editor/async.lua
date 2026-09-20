return {
  "lewis6991/async.nvim",
  lazy = false, -- Load ngay khi khởi động Neovim
  config = function()
    local ok, async = pcall(require, "async")
    if not ok then
      vim.notify("async.nvim failed: " .. tostring(async), vim.log.levels.ERROR)
    else
      _G.async = async -- Cho phép các plugin khác dùng async toàn cục
    end
  end,
}
