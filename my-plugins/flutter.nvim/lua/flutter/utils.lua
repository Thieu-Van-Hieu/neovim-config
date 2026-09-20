local snacks = require("snacks")

local M = {}

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
      if on_back and not picker.confirmed then
        vim.schedule(function()
          on_back(picker)
        end)
      end
    end,
  }

  -- Gộp các tùy chọn (opts sẽ ghi đè defaults nếu trùng)
  local final_opts = vim.tbl_deep_extend("force", defaults, opts)

  return snacks.picker.pick(final_opts)
end

-- Hàm chọn một mục từ danh sách với Snacks Picker
--- @param items table Danh sách các mục để chọn
--- @param opts table Các tùy chọn cho picker
--- @param on_confirm fun(item: table) Hàm gọi khi người dùng xác nhận lựa chọn
--- @param on_back fun() | nil Hàm gọi khi picker bị đóng mà không confirm
function M.select(items, opts, on_confirm, on_back)
  local defaults = {
    items = items,
    prompt = opts.prompt or "Select: ",
    format = opts.format or "text",
    kind = opts.kind,
    confirm = function(picker, item)
      picker:close()
      picker.confirmed = true -- Đánh dấu để on_close không gọi on_back
      if on_confirm and item then
        vim.schedule(function()
          on_confirm(item)
        end)
      end
    end,
  }

  -- Tận dụng hàm M.pick để có chung UI (Esc/Q/Layout)
  local final_opts = vim.tbl_deep_extend("force", defaults, opts)
  return M.pick(final_opts, on_back)
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
      auto_close = true,
      win = {
        position = "bottom",
        height = 0.4,
        style = "simple",
        wo = {
          winbar = "", -- Tắt winbar nếu nó gây lỗi gọi b:term_title
        },
      },
      title = title,
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

-- Trong file flutter/utils.lua
function M.get_flutter_root()
  -- Tìm file pubspec.yaml từ thư mục hiện tại ngược lên trên
  local root_file = vim.fs.find({ "pubspec.yaml" }, { upward = true, stop = vim.loop.os_homedir() })[1]
  if root_file then
    return vim.fn.fnamemodify(root_file, ":h") -- Trả về đường dẫn thư mục chứa file
  end
  return nil
end

return M
