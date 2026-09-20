local M = {}

---@class PioCreateConfig
---@field board string? Mã board PlatformIO (ví dụ: uno, esp32dev)
---@field name string Tên dự án PlatformIO
---@field path string Đường dẫn nơi tạo dự án
M.create_config = {
  board = nil,
  name = "my_pio_project",
  path = vim.fn.getcwd(),
}

---@class PioRunConfig
---@field port string? Cổng nối tiếp (ví dụ: COM3, /dev/ttyUSB0)
---@field baud number | string Tốc độ truyền (ví dụ: 9600, 115200
M.run_config = {
  port = nil,
  baud = 9600,
}

return M
