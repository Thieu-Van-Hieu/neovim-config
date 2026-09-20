-- 1. Hàm Toggle cho copilot.lua
local copilot_utils = require("utils.plugins.suggestions.copilot-utils")

require("which-key").add({
  { "<leader>C", copilot_utils.toggle, desc = "Copilot AI", mode = "n" },
})

-- 2. Cấu hình phím Tab (Tích hợp với nvim-cmp)
-- Lưu ý: copilot.lua thường được cấu hình để hiện gợi ý dạng "ghost text"
-- Nếu bạn muốn nhấn Tab để chấp nhận gợi ý ghost text:
vim.keymap.set("i", "<Tab>", function()
  local suggestion = require("copilot.suggestion")
  if suggestion.is_visible() then
    suggestion.accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
  end
end, { desc = "Copilot Accept Tab" })

local suggestion = require("copilot.suggestion")

-- 3. Các phím tắt bổ trợ khác cho copilot.lua
vim.keymap.set("i", "<M-w>", function()
  suggestion.accept_word()
end, { desc = "Accept Word" })
vim.keymap.set("i", "<M-e>", function()
  suggestion.accept_line()
end, { desc = "Accept Line" })
vim.keymap.set("i", "<M-]>", function()
  suggestion.next()
end, { desc = "Next Suggestion" })
vim.keymap.set("i", "<M-[>", function()
  suggestion.prev()
end, { desc = "Prev Suggestion" })
vim.keymap.set("i", "<M-\\>", function()
  suggestion.dismiss()
end, { desc = "Dismiss Suggestion" })
