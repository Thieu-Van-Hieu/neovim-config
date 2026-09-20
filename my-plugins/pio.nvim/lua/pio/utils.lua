local M = {}

function M.format_size(bytes)
  if not bytes or bytes == 0 then
    return "0B"
  end

  -- Nếu lớn hơn hoặc bằng 1GB (1024^3 bytes)
  if bytes >= 1073741824 then
    return string.format("%.1fGB", bytes / 1073741824)
  end

  -- Nếu lớn hơn hoặc bằng 1MB (1024^2 bytes)
  if bytes >= 1048576 then
    return string.format("%.1fMB", bytes / 1048576)
  end

  -- Nếu lớn hơn hoặc bằng 1KB
  if bytes >= 1024 then
    return string.format("%.1fKB", bytes / 1024)
  end

  return string.format("%dB", bytes)
end

function M.get_pio_root()
  local root = vim.fs.find({ "platformio.ini" }, { upward = true, path = vim.fn.expand("%:p:h") })[1]
  return root and vim.fn.fnamemodify(root, ":h") or nil
end

function M.open_terminal(cmd, root, title, opts)
  opts = opts or {}
  vim.api.nvim_command("stopinsert")

  -- Đảm bảo cmd không rỗng để tránh lỗi khởi tạo terminal
  cmd = cmd or vim.o.shell

  vim.defer_fn(function()
    require("snacks").terminal(cmd, {
      cwd = root,
      interactive = true,
      auto_close = cmd:find("monitor") ~= nil,
      win = { position = "bottom", height = 0.4, style = "simple" },
      title = " PIO: " .. title .. " ",
      on_exit = function(res)
        -- Gọi callback của người dùng nếu có
        if opts.on_exit then
          opts.on_exit(res)
        end

        -- Giải quyết lỗi không xóa buf:
        -- Ép đóng buffer sau khi terminal kết thúc để giải phóng biến b:
        local buf = vim.api.nvim_get_current_buf()
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end,
    })
  end, 50)
end

--- Đọc cấu hình từ file platformio.ini
--- @param root string Đường dẫn thư mục gốc của project
--- @return table { port: string|nil, baud: string|nil }
function M.get_ini_config(root)
  local config = { port = nil, baud = nil }
  if not root then
    return config
  end

  local ini_path = root .. "/platformio.ini"
  local f = io.open(ini_path, "r")
  if not f then
    return config
  end

  for line in f:lines() do
    -- 1. Xóa ký tự xuống dòng của Windows (\r) và khoảng trắng ở hai đầu dòng
    line = line:gsub("%s+$", ""):gsub("^%s+", "")

    -- 2. Bỏ qua các dòng chú thích hoặc dòng trống
    if line ~= "" and not line:match("^;") and not line:match("^#") then
      -- 3. Tìm port (không dùng ^ ở match để tránh lỗi khoảng trắng)
      local port = line:match("upload_port%s*=%s*(.+)") or line:match("monitor_port%s*=%s*(.+)")
      if port then
        config.port = port
      end

      -- 4. Tìm monitor_speed
      local baud = line:match("monitor_speed%s*=%s*(.+)")
      if baud then
        config.baud = baud
      end
    end
  end
  f:close()
  return config
end

-- Hàm wrapper cho Snacks Picker
--- @param opts table Các tùy chọn cho picker
--- @param on_back fun(picker: snacks.picker) | nil Hàm gọi khi picker bị đóng mà không confirm
function M.pick(opts, on_back)
  local defaults = {
    focus = opts.focus or "list", -- Luôn vào Normal Mode mặc định
    layout = { preview = nil },
    win = {
      input = {
        keys = {
          ["q"] = "close",
          ["<Esc>"] = "close",
        },
      },
    },
    -- Tự động quay lại menu trước đó nếu bị đóng mà không confirm
    on_close = opts.on_close or function(picker)
      if on_back then
        vim.schedule(function()
          on_back(picker)
        end)
      end
    end,
  }

  -- Gộp các tùy chọn (opts sẽ ghi đè defaults nếu trùng)
  local final_opts = vim.tbl_deep_extend("force", defaults, opts)

  return require("snacks").picker.pick(final_opts)
end

return M
