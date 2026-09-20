-- Tạo một nhóm Autocmd riêng (AuGroup)
local augroup = vim.api.nvim_create_augroup("UserStartup", { clear = true })

-- Thêm Autocmd vào sự kiện VimEnter
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    -- Chờ một chút (ví dụ: 100ms) để màn hình ổn định trước khi hiển thị
    vim.defer_fn(function()
      vim.notify("Chào mừng Mr.NoBody trở lại!", vim.log.levels.INFO, {
        title = "Xin chào!",
        timeout = 3000,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, {
            relative = "editor",
            width = 40,
            height = 5,
            row = 2,
            col = vim.api.nvim_get_option("columns") - 42,
          })
        end,
      })
    end, 100)
  end,
})
