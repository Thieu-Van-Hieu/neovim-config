local M = {}
local utils = require("flutter.utils")
local constants = require("flutter.constants")
local COMMANDS = constants.COMMANDS
local FLAGS = constants.FLAGS
local PLATFORMS = require("flutter.enums.platform").PLATFORMS
local PATHS = constants.PATHS

--- Thực hiện lệnh tạo dự án Flutter dựa trên cấu hình trong state.create_config
---@param create_config FlutterCreateConfig
function M.create_project(create_config)
  local full_path = create_config.path .. "/" .. create_config.name
  -- 1. Xử lý tạo thư mục cha nếu chưa có
  if vim.fn.isdirectory(full_path) == 0 then
    vim.fn.mkdir(full_path, "p")
  end

  -- 2. Xây dựng danh sách tham số (args)
  local args = {
    COMMANDS.CREATE, -- "flutter create"
    FLAGS.PROJECT_NAME .. create_config.name,
    FLAGS.ORG .. create_config.org,
    FLAGS.TEMPLATE .. create_config.template,
  }

  -- Xử lý Platforms
  if create_config.platforms and #create_config.platforms > 0 then
    table.insert(args, FLAGS.PLATFORM .. table.concat(create_config.platforms, ","))
  end

  -- Xử lý Android Language (Chỉ thêm nếu có android trong list platforms)
  if vim.tbl_contains(create_config.platforms, PLATFORMS.ANDROID) then
    table.insert(args, FLAGS.ANDROID_LANG .. create_config.android_language)
  end

  -- Xử lý iOS Language (Chỉ thêm nếu có ios trong list platforms)
  if vim.tbl_contains(create_config.platforms, PLATFORMS.IOS) then
    table.insert(args, FLAGS.IOS_LANG .. create_config.ios_language)
  end

  -- Thêm đường dẫn đích (Bọc trong ngoặc kép để xử lý khoảng trắng trong path)
  table.insert(args, string.format('"%s"', full_path))

  -- Ghép thành câu lệnh hoàn chỉnh
  local final_cmd = table.concat(args, " ")

  -- 3. Thực thi và hiển thị kết quả
  utils.open_terminal(final_cmd, full_path, " 🚀 Flutter Create: " .. create_config.name .. " ", {
    interactive = false, -- Đảm bảo terminal không chờ input
    auto_close = false, -- Giữ terminal mở để xem log
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.notify("✅ Dự án Flutter đã được tạo thành công!", 2)

        -- Tự động mở dự án sau khi tạo
        local main_dart = create_config.path .. "/lib/main.dart"
        if vim.fn.filereadable(main_dart) == 1 then
          vim.cmd("edit " .. main_dart)
        end
      else
        vim.notify("❌ Lỗi xảy ra khi thực hiện lệnh flutter create", 3)
      end
    end,
  })
end

-- Giả sử file này là models/device.lua hoặc gom chung vào services
local Device = require("flutter.models.flutter-device") -- Đường dẫn tới class bạn viết

---@param on_done fun(devices: FlutterDevice[])
function M.get_devices(on_done)
  -- Phải đảm bảo có flag --machine để lấy JSON
  local cmd = COMMANDS.DEVICES .. " " .. FLAGS.MACHINE
  local devices = {}

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      local raw = table.concat(data or {}, "")
      if raw ~= "" then
        local ok, decoded = pcall(vim.json.decode, raw)
        if ok and type(decoded) == "table" then
          for _, item in ipairs(decoded) do
            -- CHUYỂN ĐỔI TABLE THÔ THÀNH CLASS OBJECT
            table.insert(devices, Device.new(item))
          end
        end
      end
    end,
    on_exit = function(_, exit_code)
      -- Dù thành công hay thất bại (exit_code ~= 0),
      -- vẫn phải trả về callback để UI biết mà đóng Loading/Picker
      if exit_code ~= 0 and #devices == 0 then
        vim.notify("❌ Lỗi khi lấy danh sách thiết bị", 3)
      end

      -- Đưa về schedule để an toàn cho việc cập nhật UI Neovim
      vim.schedule(function()
        on_done(devices)
      end)
    end,
  })
end

---@param run_config FlutterRunConfig
--- Thực hiện lệnh chạy dự án Flutter dựa trên cấu hình trong state.run_config
function M.execute_run(run_config)
  if not run_config.device then
    vim.notify("⚠️ Bạn chưa chọn thiết bị!", vim.log.levels.WARN)
    return
  end

  -- Xây dựng chuỗi lệnh
  local cmd = {
    constants.COMMANDS.RUN,
    "-d " .. run_config.device.id,
    "--" .. run_config.mode,
    "-t " .. run_config.entry_point,
  }

  -- Thêm dart-defines nếu có
  for k, v in pairs(run_config.dart_defines) do
    table.insert(cmd, string.format("--dart-define=%s=%s", k, v))
  end

  local final_cmd = table.concat(cmd, " ")

  -- Thực thi qua terminal của utils
  utils.open_terminal(final_cmd, vim.fn.getcwd(), " 🖥️ Flutter Run [" .. run_config.device.name .. "] ")
end

local config_file = PATHS.RUN_CONFIG
function M.save_run_config(run_cfg)
  local data = {
    device_id = run_cfg.device and run_cfg.device.id or nil,
    mode = run_cfg.mode,
    entry_point = run_cfg.entry_point,
  }
  local dir = vim.fn.fnamemodify(config_file, ":h")
  vim.fn.mkdir(dir, "p")
  local f = io.open(config_file, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
  end
end

---@return FlutterRunConfig|nil
function M.load_run_config()
  local f = io.open(config_file, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()
  return vim.json.decode(content)
end

function M.fetch_sync_suggestions(query)
  if not query or query == "" then
    return {}
  end

  -- 1. Encode query để tránh lỗi khi có khoảng trắng hoặc ký tự đặc biệt
  local encoded_query = vim.uri_encode(query)
  local url = constants.URLS.PUB_DEV_PACKAGES_SEARCH .. encoded_query

  -- 2. Xử lý dấu nháy cho Windows (dùng nháy kép ") và Unix (dùng nháy đơn ')
  local is_windows = vim.fn.has("win32") == 1
  local quote = is_windows and '"' or "'"
  local cmd = string.format("curl -s -L %s%s%s", quote, url, quote)

  local handle = io.popen(cmd)
  if not handle then
    return {}
  end

  local result = handle:read("*a")
  handle:close()

  -- Kiểm tra nếu curl không trả về gì (lỗi mạng/lỗi host)
  if not result or result == "" then
    vim.notify("Curl không có dữ liệu trả về", vim.log.levels.WARN)
    return {}
  end

  -- 3. Decode JSON an toàn
  local ok, decoded = pcall(vim.json.decode, result)
  if not ok or not decoded or not decoded.packages then
    -- Nếu gõ quá nhanh, API có thể trả về lỗi hoặc format không đúng
    return {}
  end

  local packages = {}
  for i, p in ipairs(decoded.packages) do
    if i > 15 then
      break
    end
    if p.package then
      table.insert(packages, { name = p.package })
    end
  end

  return packages
end

return M
