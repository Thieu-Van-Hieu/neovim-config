-- Tự động dọn dẹp file shada tạm thời bằng stdpath
local function cleanup_shada_garbage()
  -- Lấy đường dẫn thư mục state (thường chứa shada)
  local shada_dir = vim.fn.stdpath("state") .. "/shada/"

  -- Tìm tất cả các file rác có đuôi .tmp.*
  local tmp_files = vim.fn.glob(shada_dir .. "main.shada.tmp.*", false, true)

  if #tmp_files > 0 then
    for _, file in ipairs(tmp_files) do
      -- Thử xóa file, pcall để tránh báo lỗi nếu file đang bị lock
      pcall(os.remove, file)
    end
    -- Ép ghi đè để giải phóng bộ nhớ đệm
    pcall(function()
      vim.cmd("wshada!")
    end)
  end
end

-- Thực thi ngay khi load config
cleanup_shada_garbage()
