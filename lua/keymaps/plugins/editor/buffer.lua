local function safe_close_buffer()
  local bd = require("bufdelete").bufdelete
  -- Lấy thông tin các buffer CÓ TRONG DANH SÁCH (buflisted)
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })

  -- Nếu chỉ còn 1 buffer trong danh sách buflisted (tức là buffer hiện tại)
  if #bufs <= 1 then
    bd(0, true) -- Đóng buffer cuối cùng

    -- Logic nhảy qua Neo-tree hoặc Explore nếu cần
    local ok, _ = pcall(vim.cmd, "Neotree focus")
    if not ok then
      vim.cmd("Explore") -- Fallback nếu không có Neo-tree
    end
  else
    -- Nếu còn nhiều hơn 1 buffer, chỉ cần đóng buffer hiện tại
    bd(0, true)
  end
end

local which_key = require("which-key")

which_key.add({
  -- Nhóm chính: Buffer / Tabs
  { "<leader>b", group = "Buffer" },
  { "<leader>bf", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer", mode = "n" },
  { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin", mode = "n" },
  { "<leader>br", "<Cmd>BufferLineTabRename<CR>", desc = "Rename Tab", mode = "n" },
  { "<leader>bt", "<Cmd>BufferLineGroupToggle<CR>", desc = "Toggle Group Visibility", mode = "n" },

  -- Nhóm con: Close (bc)
  { "<leader>bc", group = "Close" },
  { "<leader>bcc", safe_close_buffer, desc = "Close Current", mode = "n" },
  { "<leader>bca", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close All Others", mode = "n" },
  { "<leader>bcl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Close Left", mode = "n" },
  { "<leader>bcr", "<Cmd>BufferLineCloseRight<CR>", desc = "Close Right", mode = "n" },
  { "<leader>bcC", "<Cmd>BufferLinePickClose<CR>", desc = "Pick to Close", mode = "n" },
  { "<leader>bcg", "<Cmd>BufferLineGroupClose<CR>", desc = "Close Group", mode = "n" },

  -- Nhóm con: Move / Navigate (bm)
  { "<leader>bmm", "<Cmd>BufferLineMoveNext<CR>", desc = "Reorder Next", mode = "n" },
  { "<leader>bmb", "<Cmd>BufferLineMovePrev<CR>", desc = "Reorder Previous", mode = "n" },

  -- Nhóm con: Sort (bs)
  { "<leader>bs", group = "Sort" },
  { "<leader>bsd", "<Cmd>BufferLineSortByDirectory<CR>", desc = "By Directory", mode = "n" },
  { "<leader>bse", "<Cmd>BufferLineSortByExtension<CR>", desc = "By Extension", mode = "n" },
  { "<leader>bsr", "<Cmd>BufferLineSortByRelativeDirectory<CR>", desc = "By Relative Directory", mode = "n" },
  { "<leader>bst", "<Cmd>BufferLineSortByTabs<CR>", desc = "By Window ID", mode = "n" },
})

vim.keymap.set("n", "<tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
