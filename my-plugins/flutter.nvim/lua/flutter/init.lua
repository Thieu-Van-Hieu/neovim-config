local M = {}
local menu = require("flutter.menu")

function M.setup(opts)
  -- Tạo User Command
  vim.api.nvim_create_user_command("Flutter", menu.init, {})
end

return M
