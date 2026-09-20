-- Di chuyển đến dòng cụ thể hoặc dòng đầu tiên
vim.keymap.set({ "n", "v" }, "gg", function()
  local count = vim.v.count
  if count > 0 then
    vim.api.nvim_win_set_cursor(0, { count, 0 })
  else
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end
end, { silent = true, desc = "Jump to line (default 1)" })

-- Di chuyển đến dòng cụ thể hoặc dòng cuối cùng
vim.keymap.set({ "n", "v" }, "G", function()
  local count = vim.v.count
  if count > 0 then
    vim.api.nvim_win_set_cursor(0, { count, 0 })
  else
    local last_line = vim.api.nvim_buf_line_count(0)
    -- Nhảy đến dòng cuối, cột cuối (hoặc cột 0 tùy ý bạn)
    local last_line_content = vim.api.nvim_buf_get_lines(0, last_line - 1, last_line, false)[1]
    local last_col = #last_line_content
    vim.api.nvim_win_set_cursor(0, { last_line, last_col })
  end
end, { silent = true, desc = "Jump to line (default last)" })
