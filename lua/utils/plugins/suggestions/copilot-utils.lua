_G.copilot_current_status = nil
local is_time_out = true

local copilot_status = { ENABLED = "ENABLED", WARNING = "WARNING", DISABLED = "DISABLED", SKIP = "SKIP" }

local get_status = function()
  -- (Giữ nguyên hàm get_status của bạn)
  local ok, status = pcall(require, "copilot.status")
  if not ok then
    return copilot_status.DISABLED
  end
  local clients = vim.lsp.get_clients({ name = "copilot" })
  if #clients == 0 then
    return copilot_status.DISABLED
  end
  local client_ok, copilot_client = pcall(require, "copilot.client")
  if client_ok and copilot_client.is_disabled() then
    return copilot_status.DISABLED
  end
  local current_s = (status.data and status.data.status) or ""
  if current_s == "Warning" or current_s == "Error" then
    return copilot_status.WARNING
  end
  if current_s == "Normal" or current_s == "InProgress" then
    return copilot_status.ENABLED
  end
  return copilot_status.DISABLED
end

local toggle = function()
  -- KHÓA: Nếu chưa hết thời gian chờ thì thoát ngay (Quan trọng nhất)
  if not is_time_out then
    vim.notify("Bạn đang chuyển quá nhanh, đợi tí!", vim.log.levels.WARN, { title = "Copilot" })
    return -- Phải có return ở đây để chặn lệnh phía dưới
  end

  if _G.copilot_current_status == nil then
    _G.copilot_current_status = get_status()
  end

  -- Chặn toggle khi trạng thái không ổn định
  if _G.copilot_current_status == copilot_status.SKIP or _G.copilot_current_status == copilot_status.WARNING then
    vim.notify(
      "Trạng thái hiện tại (" .. _G.copilot_current_status .. ") không cho phép toggle",
      vim.log.levels.WARN
    )
    return
  end

  local ok, client = pcall(require, "copilot.client")
  if not ok then
    return
  end

  -- BẮT ĐẦU THỰC HIỆN & KHÓA
  is_time_out = false

  if client.is_disabled() then
    vim.cmd("Copilot enable")
    _G.copilot_current_status = copilot_status.ENABLED
    vim.notify("Copilot Enabled", vim.log.levels.INFO, { title = "Copilot" })
  else
    vim.cmd("Copilot disable")
    _G.copilot_current_status = copilot_status.DISABLED
    vim.notify("Copilot Disabled", vim.log.levels.WARN, { title = "Copilot" })
  end

  -- Làm mới thanh trạng thái ngay lập tức
  pcall(function()
    require("lualine").refresh()
  end)

  -- MỞ KHÓA SAU 5 GIÂY
  vim.defer_fn(function()
    is_time_out = true
    -- Cập nhật lại status chuẩn từ hệ thống để đảm bảo chính xác
    _G.copilot_current_status = get_status()
    pcall(function()
      require("lualine").refresh()
    end)
  end, 5000)
end

local init = function()
  _G.copilot_current_status = get_status()
end

return { init = init, get_status = get_status, toggle = toggle, copilot_status = copilot_status }
