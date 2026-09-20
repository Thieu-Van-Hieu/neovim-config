vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "VimLeavePre" }, {
	pattern = "*",
	callback = function()
		-- Kiểm tra nếu buffer hiện tại có thể lưu được và đã bị sửa đổi
		if vim.bo.modified and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
			-- "silent!" để không hiện thông báo lỗi/xác nhận
			-- "update" chỉ lưu nếu file có thay đổi (tối ưu hơn :w)
			vim.cmd("silent! update")
		end
	end,
})
