local M = {}
local menu = require("pio.menu")

function M.setup(opts)
  -- Tạo User Command
  vim.api.nvim_create_user_command("Pio", function()
    menu.open()
  end, {})

  -- Phím tắt mặc định
  vim.keymap.set("n", "<leader>P", ":Pio<CR>", { desc = "PlatformIO Menu" })
end

return M