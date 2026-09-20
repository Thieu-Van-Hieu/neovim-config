local utils = require("flutter.utils")
local constants = require("flutter.constants")
local state = require("flutter.state")
local services = require("flutter.services")

local M = {}

-- Chọn Template
function M.select_template(on_confirm, on_back)
  local items = {}
  for _, v in pairs(constants.TEMPLATES) do
    table.insert(items, { text = v, value = v })
  end

  utils.select(items, {
    title = " 🏗️  Flutter Template ",
  }, function(item)
    on_confirm(item.value)
  end, on_back)
end

-- Chọn Language
function M.select_language(type, on_confirm, on_back)
  local langs = (type == "android") and constants.LANGS.ANDROID or constants.LANGS.IOS

  local items = {}
  for _, v in pairs(langs) do
    table.insert(items, { text = v, value = v })
  end

  utils.select(items, {
    title = string.format(" 󰉺  %s Language ", type:upper()),
  }, function(item)
    on_confirm(item.value)
  end, on_back)
end

-- Chọn Platforms (Multi-select)
function M.select_platforms(on_confirm, on_back)
  local PLATFORMS = constants.PLATFORMS
  local selected_in_config = state.create_config.platforms or {}

  local items = {}
  for _, v in pairs(PLATFORMS) do
    table.insert(items, {
      text = v,
      value = v,
      selected = vim.tbl_contains(selected_in_config, v),
    })
  end

  utils.pick({
    source = "select",
    items = items,
    title = " 📱 Flutter Platforms ",
    -- Bỏ layout select để không bị dính cái checkbox mặc định ở lề trái
    layout = { preview = nil },
    format = function(item, _)
      return {
        { item.text, "SnacksPickerText" },
      }
    end,
    confirm = function(picker, item)
      -- Thay vì dùng picker:selected(), mình lọc qua toàn bộ items của picker
      local result = {}
      for _, it in ipairs(picker:selected()) do
        table.insert(result, it.value)
      end

      -- Nếu chưa bấm Space cái nào mà nhấn Enter luôn vào 1 dòng
      if #result == 0 and item then
        table.insert(result, item.value)
      end

      picker.confirmed = true
      picker:close()

      if #result > 0 then
        vim.schedule(function()
          on_confirm(result)
        end)
      else
        vim.notify("⚠️ Phải chọn ít nhất 1 platform", 3)
        if on_back then
          on_back()
        end
      end
    end,
  }, on_back)
end

-- Chọn Device
---@param on_choice fun(device: FlutterDevice)
---@param on_back fun() | nil
function M.select_device(on_choice, on_back)
  -- 1. Hiện thông báo đang quét (vì lệnh flutter devices --machine mất khoảng 1-2s)
  vim.notify("🔍 Đang tìm kiếm thiết bị...", vim.log.levels.INFO, {
    title = "Flutter",
    keep = function()
      return false
    end, -- Tự đóng khi xong
  })

  -- 2. Gọi service lấy danh sách đã được Class- hóa
  services.get_devices(function(devices)
    if #devices == 0 then
      vim.notify("⚠️ Không tìm thấy thiết bị nào đang kết nối!", vim.log.levels.WARN)
      return
    end

    -- 3. Mở Snacks Picker
    utils.pick({
      title = "📱 Chọn thiết bị Target ",
      items = devices,
      format = function(device)
        -- Sử dụng các method của Class Device bạn đã viết
        return {
          { device:get_icon(), "SnacksPickerLabel" },
          { string.format("%-15s", device.name), "SnacksPickerText" },
          { "│ ", "SnacksPickerDelim" },
          { device.target_platform, "SnacksPickerComment" },
          { device.is_emulator and " [Emulator]" or "", "SnacksPickerSpecial" },
        }
      end,
      confirm = function(picker, device)
        picker:close()

        -- Lưu vào state để các hàm Run/Debug sử dụng
        state.selected_device = device

        vim.notify("🎯 Đã chọn: " .. device.name, vim.log.levels.INFO, { title = "Flutter" })

        -- Callback nếu cần làm gì tiếp theo (ví dụ quay lại menu chính)
        if on_choice then
          on_choice(device)
        end
      end,
    }, function()
      -- Callback khi bấm hủy/quay lại
      if on_back then
        on_back()
      end
    end)
  end)
end

-- Chọn Build Mode
---@param on_choice fun(mode: string)
function M.select_build_mode(on_choice, on_back)
  local modes = { "debug", "profile", "release" }

  local items = {}
  for _, v in ipairs(modes) do
    table.insert(items, { text = v, value = v })
  end
  utils.pick({
    title = " ⚙️  Chọn Build Mode ",
    items = items,
    format = function(item, _)
      return {
        { item.text, "SnacksPickerText" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      picker.confirmed = true

      if on_choice then
        on_choice(item.value)
      end
    end,
  }, function()
    if on_back then
      on_back()
    end
  end)
end

return M
