local M = {}
M.__index = M

--- Khởi tạo một đối tượng Device mới từ dữ liệu JSON
---@param data table Dữ liệu thô từ flutter devices --machine
function M.new(data)
  local self = setmetatable({}, M)

  self.name = data.name or "Unknown Device"
  self.id = data.id or "unknown"
  self.is_supported = data.isSupported or false
  self.target_platform = data.targetPlatform or ""
  self.is_emulator = data.emulator or false
  self.sdk = data.sdk or ""
  self.capabilities = data.capabilities or {}

  return self
end

--- Lấy icon tương ứng với loại thiết bị
function M:get_icon()
  local platform = self.target_platform:lower()
  if platform:match("android") then
    return " "
  end
  if platform:match("ios") or platform:match("macos") then
    return " "
  end
  if platform:match("web") then
    return "󰖟 "
  end
  if platform:match("windows") then
    return " "
  end
  if platform:match("linux") then
    return " "
  end
  return " "
end

--- Kiểm tra xem thiết bị có hỗ trợ Hot Reload không
function M:can_hot_reload()
  return self.capabilities.hotReload == true
end

--- Trả về chuỗi hiển thị rút gọn cho Picker
function M:get_display_text()
  return string.format("%s (%s)", self.name, self.target_platform)
end

---@class FlutterDevice
return M
