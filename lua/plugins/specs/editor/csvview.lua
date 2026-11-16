return {
  {
    "hat0uma/csvview.nvim",
    -- Thay vì dùng 'cmd' (gọi thủ công), dùng 'ft' để tự động tải plugin cho các định dạng này
    ft = { "csv", "tsv" },
    opts = {
      parser = { comments = { "#", "//" } },
      display = {
        mode = "border", -- Hiển thị dạng bảng kẻ khung "│"
      },
    },
    -- Tự động kích hoạt ngay sau khi plugin được tải cấu hình xong
    config = function(_, opts)
      require("csvview").setup(opts)

      -- Tạo sự kiện tự động chạy lệnh bật giao diện bảng
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv", "tsv" },
        callback = function()
          vim.cmd("CsvViewEnable")
        end,
      })
    end,
  },
}
