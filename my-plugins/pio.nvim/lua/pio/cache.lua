local M = {}
local constants = require("pio.constants")
local COMMANDS = constants.COMMANDS
local PATHS = constants.PATHS

function M.update(type, callback)
  local configs = {
    boards = { path = PATHS.BOARDS_CACHE, cmd = COMMANDS.LIST_BOARDS, label = "Board" },
    libs = { path = PATHS.LIBS_CACHE, cmd = COMMANDS.LIST_LIBS, label = "Thư viện" },
  }
  local conf = configs[type]
  if not conf then
    return
  end

  vim.notify("🚀 Đang cập nhật " .. conf.label .. "...", 2)
  vim.fn.mkdir(vim.fn.fnamemodify(conf.path, ":h"), "p")

  vim.system(conf.cmd, { text = true }, function(obj)
    if obj.code == 0 and obj.stdout then
      local f = io.open(conf.path, "w")
      if f then
        f:write(obj.stdout)
        f:close()
      end
      vim.schedule(function()
        vim.notify("✅ Đã cập nhật xong " .. conf.label, 2)
        if callback then
          callback()
        end
      end)
    end
  end)
end

-- Get cached data
---@param type PioCacheEnum
function M.get(type)
  local path = PATHS[type]
  local f = io.open(path, "r")
  if not f then
    M.update(type)
    return nil
  end
  local content = f:read("*a")
  f:close()
  if not content or content == "" then
    M.update(type)
    return nil
  end
  local ok, data = pcall(vim.fn.json_decode, content)
  return ok and data or nil
end

return M
