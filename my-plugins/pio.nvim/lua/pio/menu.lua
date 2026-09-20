local M = {}
local state = require("pio.state")
local utils = require("pio.utils")
local picker_ui = require("pio.picker")
local services = require("pio.services")
local constants = require("pio.constants")
local COMMANDS = constants.COMMANDS
local FLAGS = constants.FLAGS

-- 1. Menu Điều khiển thực thi (Run / Upload / Monitor)
function M.run_menu()
  local root = utils.get_pio_root()
  if not root then
    return
  end

  local config = services.get_config(root, state.run_config)

  local items = {
    -- --- PHẦN CẤU HÌNH ---
    {
      idx = "1",
      key = "Baudrate",
      val = config.baud or "9600",
      action = function()
        vim.ui.input({ prompt = "Nhập Baudrate: ", default = tostring(config.baud) or "9600" }, function(input)
          if input then
            state.run_config.baud = input
          end
          M.run_menu()
        end)
      end,
    },
    {
      idx = "2",
      key = "Port",
      val = config.port or "Auto (Dò tự động)",
      action = function()
        picker_ui.select_port(function(p)
          state.run_config.port = p
          M.run_menu()
        end, M.run_menu)
      end,
    },
    -- --- PHẦN LỆNH THỰC THI ---
    {
      idx = "b",
      key = "BUILD",
      val = "🔨 Thực thi Build",
      action = function()
        utils.open_terminal(COMMANDS.BUILD, root, "Build")
      end,
    },
    {
      idx = "u",
      key = "UPLOAD",
      val = "🚀 Nạp Code",
      action = function()
        local cmd = COMMANDS.UPLOAD
        if config.port then
          cmd = cmd .. " --upload-port " .. config.port
        end
        utils.open_terminal(cmd, root, "Upload")
      end,
    },
    {
      idx = "f", -- THÊM MỚI: Upload File System
      key = "FILESYS",
      val = "📁 Nạp File System (SPIFFS/LittleFS)",
      action = function()
        local cmd = COMMANDS.UPLOAD_FS
        if config.port then
          cmd = cmd .. " --upload-port " .. config.port
        end
        utils.open_terminal(cmd, root, "Upload FS")
      end,
    },
    {
      idx = "a", -- THÊM MỚI: Combo Upload + Monitor
      key = "COMBO",
      val = "🔥 Nạp Code & Mở Monitor",
      action = function()
        local cmd = COMMANDS.UPLOAD .. " && " .. COMMANDS.MONITOR
        if config.port then
          -- Thêm port cho cả nạp và monitor
          cmd = string.format(
            "%s %s %s && %s %s %s",
            COMMANDS.UPLOAD,
            FLAGS.UPLOAD_PORT,
            config.port,
            COMMANDS.MONITOR,
            FLAGS.PORT,
            config.port
          )
        end
        if config.baud then
          cmd = string.format("%s %s %s", cmd, FLAGS.BAUD, config.baud)
        end
        utils.open_terminal(cmd, root, "Upload & Monitor")
      end,
    },
    {
      idx = "m",
      key = "MONITOR",
      val = "🖥️  Serial Monitor",
      action = function()
        local cmd = COMMANDS.MONITOR
        if config.port then
          cmd = string.format("%s %s %s", cmd, FLAGS.PORT, config.port)
        end
        if config.baud then
          cmd = string.format("%s %s %s", cmd, FLAGS.BAUD, config.baud)
        end
        utils.open_terminal(cmd, root, "Monitor")
      end,
    },
  }

  for _, item in ipairs(items) do
    item.text = string.format("%s %s %s", item.idx, item.key, tostring(item.val))
  end

  local selected_item = nil

  utils.pick({
    title = "🚀 PIO Run: " .. vim.fn.fnamemodify(root, ":t"),
    items = items,
    format = function(item)
      local idx_str = tostring(item.idx)
      -- Highlight các phím chữ (lệnh thực thi) khác với phím số (cài đặt)
      local is_cmd = idx_str:match("%a")

      return {
        { idx_str .. ". ", "SnacksPickerLabel" },
        { string.format("%-10s: ", item.key), is_cmd and "SnacksPickerLabel" or "SnacksPickerText" },
        { tostring(item.val), is_cmd and "SnacksPickerComment" or "SnacksPickerSpecial" },
      }
    end,
    confirm = function(p, item)
      p:close()
      selected_item = item
      vim.schedule(item.action)
    end,
  }, function()
    if not selected_item or (selected_item.idx ~= 1 and selected_item.idx ~= 2) then
      M.open()
    end
  end)
end

-- 2. Commander Chính (Lối vào)
function M.open()
  local root = utils.get_pio_root()
  local items = {
    { idx = "n", name = "✨ New Project", action = M.create_project_menu },
  }

  if root then
    table.insert(items, {
      idx = "r",
      name = "🛠️  Run / Upload / Monitor...",
      action = M.run_menu,
    })
    -- THÊM OPTION MỚI ĐỂ CHẠY LỆNH INIT VÀ COMPILEDB
    table.insert(items, {
      idx = "s", -- Phím tắt 's' cho Sync/Setup
      name = "🔄 Sync & Setup (LSP)",
      action = function()
        -- Chạy lệnh cơ bản để PIO tự dò
        local cmd = string.format("%s && %s", COMMANDS.INIT_VIM, COMMANDS.COMPILE_DB)

        utils.open_terminal(cmd, root, "SYNC PROJECT", {
          auto_close = false,
          on_exit = function(_, code)
            if code == 0 then
              vim.schedule(function()
                vim.cmd("LspRestart")
                vim.notify("✅ Đồng bộ hóa thành công! LSP đã sẵn sàng.", vim.log.levels.INFO)
              end)
            end
          end,
        })
      end,
    })
    table.insert(items, {
      idx = "i",
      name = "⚙️  Edit platformio.ini",
      action = function()
        vim.cmd("edit " .. root .. "/platformio.ini")
      end,
    })
  end

  for _, item in ipairs(items) do
    item.text = item.idx .. " " .. item.name
  end

  utils.pick({
    title = root and ("PIO Project: " .. vim.fn.fnamemodify(root, ":t")) or "PlatformIO",
    items = items,
    format = function(item)
      return {
        { item.idx .. " ", "SnacksPickerLabel" },
        { item.name, "SnacksPickerText" },
      }
    end,
    confirm = function(p, item)
      p:close()
      vim.schedule(item.action)
    end,
  })
end

-- 3. Menu Init Project (Khởi tạo dự án mới)
function M.create_project_menu()
  local items = {
    {
      idx = "1",
      key = "Board",
      val = state.create_config.board or "Chưa chọn",
      action = function()
        picker_ui.select_board(M.create_project_menu)
      end,
    },
    {
      idx = "2",
      key = "Tên",
      val = state.create_config.name,
      action = function()
        vim.ui.input({ prompt = "Tên Project: ", default = state.create_config.name }, function(i)
          if i then
            state.create_config.name = i
          end
          M.create_project_menu()
        end)
      end,
    },
    {
      idx = "3",
      key = "Nơi lưu",
      val = state.create_config.path,
      action = function()
        vim.ui.input(
          { prompt = "Đường dẫn: ", default = state.create_config.path, completion = "dir" },
          function(i)
            if i then
              state.create_config.path = i
            end
            M.create_project_menu()
          end
        )
      end,
    },
    {
      idx = "5",
      key = "DONE",
      val = "🚀 KHỞI TẠO",
      action = function()
        if not state.create_config.board or state.create_config.board == "Chưa chọn" then
          vim.notify("⚠️ Vui lòng chọn Board trước!", vim.log.levels.WARN)
          -- Gọi lại chính nó để hiện lại menu sau khi thông báo
          M.create_project_menu()
          return
        end
        services.create_project(state.create_config)
      end,
    },
  }

  for _, item in ipairs(items) do
    item.text = item.idx .. " " .. item.key .. " " .. tostring(item.val)
  end

  local selected_item = nil
  utils.pick({
    title = "🛠️ Setup Project",
    items = items,
    format = function(item)
      return {
        { item.idx .. ". ", "SnacksPickerLabel" },
        { string.format("%-10s: ", item.key), "SnacksPickerText" },
        { tostring(item.val), "SnacksPickerComment" },
      }
    end,
    confirm = function(p, item)
      p:close()
      selected_item = item
      vim.schedule(item.action)
    end,
  }, function()
    if selected_item == nil then
      M.open()
    end
  end)
end

return M
