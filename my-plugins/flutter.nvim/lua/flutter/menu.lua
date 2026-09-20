local M = {}
local state = require("flutter.state")
local utils = require("flutter.utils")
local picker_ui = require("flutter.picker") -- File chứa select_template, select_language...
local services = require("flutter.services")
local constants = require("flutter.constants")

function M.init()
  local items = {
    {
      label = "🔨 Tạo dự án mới",
      action = function()
        M.create_project_menu()
      end,
    },
  }

  if utils.get_flutter_root() then
    local saved_data = services.load_run_config()
    if saved_data then
      state.run_config.mode = saved_data.mode or state.run_config.mode
      state.run_config.entry_point = saved_data.entry_point or state.run_config.entry_point

      -- Nếu có device_id cũ, ta cần tìm lại object Device tương ứng
      if saved_data.device_id and not state.run_config.device then
        services.get_devices(function(devices)
          for _, dev in ipairs(devices) do
            if dev.id == saved_data.device_id then
              state.run_config.device = dev
              break
            end
          end
        end)
      end
    end
    table.insert(items, {
      label = "⚡ Chạy dự án hiện tại",
      action = function()
        M.run_project_menu()
      end,
    })
    table.insert(items, {
      label = "📱 Danh sách thiết bị",
      action = function()
        picker_ui.select_device(function(_) end, M.init)
      end,
    })
    table.insert(items, {
      label = "🧹 Pub Clean",
      action = function()
        utils.open_terminal("flutter clean")
      end,
    })
    table.insert(items, {
      label = "📦 Tìm kiếm Pub Package",
      action = function()
        M.search_pub_packages()
      end,
    })
  end

  utils.pick({
    title = "💙 Flutter Neovim Manager",
    items = items,
    format = function(item)
      return { { item.label, "SnacksPickerText" } }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.schedule(item.action)
    end,
  })
end

function M.create_project_menu()
  local items = {
    {
      idx = "1",
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
      idx = "2",
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
      idx = "3",
      key = "Template",
      val = state.create_config.template,
      action = function()
        picker_ui.select_template(function(choice)
          state.create_config.template = choice
          M.create_project_menu()
        end, M.create_project_menu)
      end,
    },
    {
      idx = "4",
      key = "Platforms",
      val = table.concat(state.create_config.platforms, ", "),
      action = function()
        picker_ui.select_platforms(function(choices)
          state.create_config.platforms = choices
          M.create_project_menu()
        end, M.create_project_menu)
      end,
    },
  }

  -- Logic động: Kiểm tra Android Language
  if vim.tbl_contains(state.create_config.platforms, constants.PLATFORMS.ANDROID) then
    table.insert(items, {
      idx = "5",
      key = "Android Lang",
      val = state.create_config.android_language,
      action = function()
        picker_ui.select_language("android", function(choice)
          state.create_config.android_language = choice
          M.create_project_menu()
        end, M.create_project_menu)
      end,
    })
  end

  -- Logic động: Kiểm tra iOS Language
  if vim.tbl_contains(state.create_config.platforms, constants.PLATFORMS.IOS) then
    table.insert(items, {
      idx = "6",
      key = "iOS Lang",
      val = state.create_config.ios_language or constants.LANGS.IOS.SWIFT,
      action = function()
        picker_ui.select_language("ios", function(choice)
          state.create_config.ios_language = choice
          M.create_project_menu()
        end, M.create_project_menu)
      end,
    })
  end

  -- Nút thực thi cuối cùng
  table.insert(items, {
    idx = "D",
    key = "DONE",
    val = "🚀 KHỞI TẠO PROJECT",
    action = function()
      services.create_project(state.create_config)
    end,
  })

  -- Sử dụng utils.pick theo wrapper bạn đã cung cấp
  utils.pick({
    title = "🛠️ Flutter Create Setup",
    items = items,
    format = function(item)
      local is_done = item.idx == "D"
      return {
        { item.idx .. ". ", "SnacksPickerLabel" },
        { string.format("%-15s: ", item.key), is_done and "SnacksPickerLabel" or "SnacksPickerText" },
        { tostring(item.val), is_done and "SnacksPickerSpecial" or "SnacksPickerComment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      vim.schedule(item.action)
    end,
  }, M.init)
end

--- Menu điều khiển chạy dự án Flutter
function M.run_project_menu()
  local run_cfg = state.run_config

  local items = {
    {
      idx = "1",
      key = "Thiết bị",
      -- Hiển thị Icon + Tên nếu đã chọn, nếu chưa thì báo đỏ
      val = run_cfg.device and (run_cfg.device:get_icon() .. run_cfg.device.name) or "Chọn thiết bị...",
      action = function()
        picker_ui.select_device(function(selected)
          run_cfg.device = selected
        end, M.run_project_menu)
      end,
    },
    {
      idx = "2",
      key = "Chế độ",
      val = run_cfg.mode,
      action = function()
        -- Bạn có thể dùng vim.ui.select hoặc utils.pick đơn giản để chọn mode
        picker_ui.select_build_mode(function(choice)
          run_cfg.mode = choice
        end, M.run_project_menu)
      end,
    },
    {
      idx = "3",
      key = "Entry Point",
      val = run_cfg.entry_point,
      action = function()
        vim.ui.input({ prompt = "Đường dẫn file chính: ", default = run_cfg.entry_point }, function(i)
          if i then
            run_cfg.entry_point = i
          end
          M.run_project_menu()
        end)
      end,
    },
  }

  -- Nút thực thi Run
  table.insert(items, {
    idx = "R",
    key = "RUN",
    val = "🚀 CHẠY DỰ ÁN",
    action = function()
      services.execute_run(run_cfg)
      services.save_run_config(run_cfg)
    end,
  })

  local selected_item = nil
  utils.pick({
    title = "⚡ Flutter Run Setup",
    items = items,
    format = function(item)
      local is_run = item.idx == "R"
      return {
        { item.idx .. ". ", "SnacksPickerLabel" },
        { string.format("%-15s: ", item.key), is_run and "SnacksPickerLabel" or "SnacksPickerText" },
        { tostring(item.val), is_run and "SnacksPickerSpecial" or "SnacksPickerComment" },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      selected_item = item
      vim.schedule(item.action)
    end,
  }, function()
    if selected_item == nil then
      M.init()
    end
  end)
end

function M.search_pub_packages()
  utils.pick({
    title = "📦 Tìm kiếm Pub Package",
    focus = "insert",
    debounce = 1000,
    live = true,
    finder = function(opts, ctx)
      local filter = ctx.filter.search

      if not filter or #filter < 2 then
        return {}
      end

      local suggestions = services.fetch_sync_suggestions(filter)

      local results = {}
      for _, pkg in ipairs(suggestions) do
        table.insert(results, {
          text = pkg.name,
          value = pkg.name,
        })
      end
      return results
    end,
    format = function(item)
      return {
        { " 📦 ", "SnacksPickerIcon" },
        { item.text, "SnacksPickerText" },
      }
    end,
    --- Xử lý khi người dùng xác nhận chọn một package
    --- @param picker snacks.picker
    confirm = function(picker)
      picker:close()
      local selected_packages = {}
      for _, it in ipairs(picker:selected()) do
        table.insert(selected_packages, it.value)
      end
      if #selected_packages == 0 then
        return
      end
      vim.schedule(function()
        utils.open_terminal("flutter pub add " .. table.concat(selected_packages, " "))
      end)
    end,
  }, function()
    M.init()
  end)
end

return M
