local copilot_utils = require("utils.plugins.suggestions.copilot-utils")

local M = {}

-- --------------------------
-- CẤU HÌNH ĐỒNG HỒ
-- --------------------------
local clock_icons = {
  [0] = "󱑖 ",
  [1] = "󱑋 ",
  [2] = "󱑌 ",
  [3] = "󱑍 ",
  [4] = "󱑎 ",
  [5] = "󱑏 ",
  [6] = "󱑐 ",
  [7] = "󱑑 ",
  [8] = "󱑒 ",
  [9] = "󱑓 ",
  [10] = "󱑔 ",
  [11] = "󱑕 ",
}

local function get_time_icon(hour)
  if hour >= 22 or hour < 5 then
    return " " -- Đêm khuya
  elseif hour >= 5 and hour < 12 then
    return " " -- Sáng
  elseif hour >= 12 and hour < 18 then
    return "󰖨 " -- Chiều
  else
    return "󰼱 "
  end -- Tối
end

function M.get_time_component()
  if vim.bo.filetype == "neo-tree" then
    return ""
  end
  local hour = tonumber(os.date("%H"))
  local clock = clock_icons[hour % 12] or " "
  local weekday = ({ ["0"] = "CN", ["1"] = "T2", ["2"] = "T3", ["3"] = "T4", ["4"] = "T5", ["5"] = "T6", ["6"] = "T7" })[os.date(
    "%w"
  )]
  return string.format("%s %s - %s %s", get_time_icon(hour), weekday, clock, os.date("%H:%M:%S"))
end

-- --------------------------
-- CẤU HÌNH COPILOT
-- --------------------------
M.copilot_pill_map = {
  ENABLED = { icon = " ", style = { fg = "#232a2f", bg = "#ba8ef7", gui = "bold" } },
  WARNING = { icon = " ", style = { fg = "#232a2f", bg = "#f7ab8f", gui = "bold" } },
  DISABLED = { icon = " ", style = { fg = "#8b949e", bg = "#30363d" } },
}

return M
