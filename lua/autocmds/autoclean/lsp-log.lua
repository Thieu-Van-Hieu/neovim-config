local augroup = vim.api.nvim_create_augroup("LspLogCleaner", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    -- Luôn tắt log level ngay lập tức để chặn spam
    vim.defer_fn(function()
      local log_path = vim.lsp.get_log_path()

      if vim.fn.filereadable(log_path) == 1 then
        -- Dùng pcall làm "Try-Catch" cho việc mở file
        local status, err = pcall(function()
          local f = io.open(log_path, "w")
          if f then
            f:write("")
            f:close()
            return true
          else
            error("Không thể mở file trực tiếp") -- Ép nhảy xuống phần catch (os.execute)
          end
        end)

        -- Nếu BƯỚC 2 thất bại (status == false), thực hiện BƯỚC 3 (Catch)
        if not status then
          pcall(function()
            -- Ép ghi đè bằng lệnh hệ thống Windows (An toàn hơn khi file bị lock)
            os.execute('type nul > "' .. log_path:gsub("/", "\\") .. '"')
          end)
        end

        -- Thông báo nhẹ nhàng cho bạn biết đã xong (có thể bỏ dòng này nếu muốn im lặng)
        -- vim.notify("✅ Log cleaned (Safe Mode)", vim.log.levels.INFO)
      end
    end, 500)
  end,
})
