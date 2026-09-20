local mc = require("multicursor-nvim")
local mc_state = { last_direction = 1 }

-- Ctrl + d: Chọn xuống
vim.keymap.set({ "n", "x" }, "<C-d>", function()
  mc_state.last_direction = 1
  mc.matchAddCursor(1)
end)

-- Ctrl + u: Logic sửa lỗi "sida" (Nếu đang đi xuống thì Undo, nếu không thì chọn lên)
vim.keymap.set({ "n", "x" }, "<C-u>", function()
  if mc.numCursors() > 1 and mc_state.last_direction == 1 then
    mc.deleteCursor()
  else
    mc_state.last_direction = -1
    mc.matchAddCursor(-1)
  end
end)

-- Ctrl + x: Bỏ qua (Skip)
vim.keymap.set({ "n", "x" }, "<C-x>", function()
  mc.matchSkipCursor(mc_state.last_direction)
end)

-- Clone hàng loạt (Alt + u/d)
vim.keymap.set({ "n", "x" }, "<M-u>", function()
  mc.lineAddCursor(-1)
end)
vim.keymap.set({ "n", "x" }, "<M-d>", function()
  mc.lineAddCursor(1)
end)

-- Keymap Layer (Chỉ có tác dụng khi đang có nhiều con trỏ)
mc.addKeymapLayer(function(layerSet)
  layerSet("n", "<esc>", function()
    if mc.hasCursors() then
      mc.clearCursors()
      mc_state.last_direction = 1
      vim.cmd("nohlsearch")
    end
  end)
  layerSet({ "n", "x" }, "<left>", mc.prevCursor)
  layerSet({ "n", "x" }, "<right>", mc.nextCursor)
  layerSet("n", "<leader>a", mc.alignCursors)
end)
