local M = {}
local state = require("pio.state")
local utils = require("pio.utils")
local cache = require("pio.cache")
local constants = require("pio.constants")
local COMMANDS = constants.COMMANDS
function M.select_board(on_confirm)
  local boards = cache.get(constants.CACHES.BOARDS)
  if not boards then
    return
  end

  local items = {}
  for _, b in ipairs(boards) do
    table.insert(items, {
      text = string.format("%s %s %s", b.id, b.name, b.mcu),
      id = b.id,
      name = b.name,
      ram = utils.format_size(b.ram),
      rom = utils.format_size(b.rom),
    })
  end

  utils.pick({
    title = "Chọn Board",
    items = items,
    focus = "input",
    format = function(item)
      return {
        { string.format("%-25s", item.id), "SnacksPickerLabel" },
        { " " .. item.name, "SnacksPickerText" },
        { string.format(" %s/%s", item.ram, item.rom), "SnacksPickerSpecial" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      state.create_config.board = item.id
    end,
  }, on_confirm) -- Truyền on_confirm vào đây để làm hàm on_back
end

function M.select_port(callback, on_back)
  vim.notify("🔌 Đang quét cổng...", 2)
  vim.system(COMMANDS.LIST_PORTS, { text = true }, function(obj)
    vim.schedule(function()
      local items = {}
      if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
        -- json_decode bây giờ được gọi an toàn trong main loop
        local ok, ports = pcall(vim.fn.json_decode, obj.stdout)
        if ok and type(ports) == "table" then
          for _, p in ipairs(ports) do
            table.insert(items, {
              text = p.port .. " " .. (p.description or ""),
              port = p.port,
            })
          end
        end
      end

      if #items == 0 then
        vim.notify("⚠️ Không tìm thấy cổng COM", 2)
        if on_back then
          on_back()
        end
        return
      end

      utils.pick({
        title = "Chọn Cổng COM",
        items = items,
        format = function(item)
          return {
            { "🔌 ", "SnacksPickerIcon" },
            { item.port, "SnacksPickerLabel" }, -- Hiển thị tên port (vd: COM3)
            { " " .. (item.desc or ""), "SnacksPickerComment" }, -- Hiển thị mô tả nếu có
          }
        end,
        confirm = function(p, i)
          p:close()
          callback(i.port)
        end,
      }, on_back)
    end)
  end)
end

return M
