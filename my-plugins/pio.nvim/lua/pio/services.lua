local M = {}
local constants = require("pio.constants")
local utils = require("pio.utils")
local COMMANDS = constants.COMMANDS
local FLAGS = constants.FLAGS

-- Lấy cấu hình chạy từ state hoặc file ini
---@param root string Thư mục gốc của dự án PlatformIO
---@param run_config PioRunConfig Trạng thái cấu hình chạy hiện tại
function M.get_config(root, run_config)
  local ini = utils.get_ini_config(root)
  local current = run_config or {}

  return {
    port = ini.port or current.port,
    baud = ini.baud or current.baud,
  }
end

-- Tạo dự án PlatformIO
---@param create_config PioCreateConfig
function M.create_project(create_config)
  local full_path = create_config.path .. "/" .. create_config.name

  -- Biến này để đánh dấu nếu folder đã tồn tại từ trước (tránh xóa nhầm dữ liệu cũ)
  local already_existed = vim.fn.isdirectory(full_path) == 1

  -- 1. Thao tác File bằng Lua
  if not already_existed then
    -- Sử dụng pcall để xử lý nếu mkdir lỗi
    pcall(vim.fn.mkdir, full_path, "p")
  end

  local src_path = full_path .. "/src"
  pcall(vim.fn.mkdir, src_path, "p")

  -- Tạo file main.cpp với nội dung chi tiết hơn
  local main_path = src_path .. "/main.cpp"
  local f = io.open(main_path, "w")
  if f then
    f:write("#include <Arduino.h>\n\n")
    f:write("void setup() {\n  Serial.begin(115200);\n}\n\n") -- Thêm Serial.begin
    f:write("void loop() {\n}\n")
    f:close()
  end

  -- 2. Lệnh Shell (Chạy init và compiledb)
  local init_cmd =
    string.format("%s %s %s && %s", COMMANDS.INIT_VIM, FLAGS.BOARD, create_config.board, COMMANDS.COMPILE_DB)

  vim.notify("🚀 Đang khởi tạo dự án PlatformIO...", vim.log.levels.INFO)

  -- Sử dụng utils.open_terminal thay vì open_pio_terminal
  utils.open_terminal(init_cmd, full_path, "INIT PROJECT", {
    interactive = false, -- Đảm bảo terminal không chờ input
    auto_close = false, -- Giữ terminal mở để xem log
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if exit_code == 0 then
          -- THÀNH CÔNG
          vim.api.nvim_set_current_dir(full_path)
          vim.cmd("edit " .. vim.fn.fnameescape(main_path))
          vim.cmd("LspRestart") -- Khởi động lại LSP
          if Snacks.explorer then
            Snacks.explorer.open({ cwd = full_path }) -- Mở explorer
          end
          vim.notify("✅ Hoàn tất! LSP đã sẵn sàng.", vim.log.levels.INFO)
        else
          -- THẤT BẠI: Dọn dẹp folder lỗi
          if not already_existed then
            vim.notify("🧹 Khởi tạo lỗi. Đang dọn dẹp thư mục dự án...", vim.log.levels.WARN)
            vim.fn.delete(full_path, "rf") -- Xóa đệ quy folder vừa tạo
            vim.notify("❌ Đã xóa thư mục dự án lỗi: " .. create_config.name, vim.log.levels.ERROR)
          else
            vim.notify(
              "❌ Lỗi khởi tạo, nhưng thư mục đã tồn tại từ trước nên không xóa.",
              vim.log.levels.ERROR
            )
          end
        end
      end)
    end,
  })
end

return M
