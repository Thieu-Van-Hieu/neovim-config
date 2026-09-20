local function run_multiple_overseer_tasks()
  local ok, overseer = pcall(require, "overseer")
  if not ok then
    return
  end

  -- 1) Lấy danh sách tasks từ Taskfile.dev CLI
  local output = vim.fn.systemlist({ "task", "--list" })
  if vim.v.shell_error ~= 0 then
    vim.notify(
      "Không chạy được `task --list`. Hãy cài Taskfile.dev CLI (lệnh: task) và đảm bảo đang đứng đúng thư mục project có Taskfile.yml",
      vim.log.levels.ERROR
    )
    return
  end

  -- 2) Parse output thành items cho picker (giữ UI cũ)
  local items = {}
  for _, line in ipairs(output) do
    -- Hỗ trợ 2 kiểu phổ biến:
    -- "* build: Build project"
    -- "build: Build project"
    local name, desc = line:match("^%s*%*%s*([%w%-%_%.]+)%s*:%s*(.*)$")
    if not name then
      name, desc = line:match("^%s*([%w%-%_%.]+)%s*:%s*(.*)$")
    end

    if name and name ~= "" then
      desc = (desc and desc ~= "") and desc or "No description"
      table.insert(items, {
        index = #items + 1,
        text = name,
        desc = desc,
      })
    end
  end

  if #items == 0 then
    vim.notify(
      "Không tìm thấy task nào trong `task --list` (hoặc output không parse được).",
      vim.log.levels.WARN
    )
    return
  end

  -- 3) Picker UI giữ nguyên như bạn đang dùng
  Snacks.picker.pick({
    source = "select",
    items = items,
    layout = { preset = "select" },
    title = "Taskfile tasks",
    format = function(item, _)
      return {
        { item.index .. ". ", "SnacksPickerIdx" },
        { item.text, "SnacksLabel" },
        { " " .. string.format("(%s)", item.desc), "SnacksDescription" },
      }
    end,

    confirm = function(picker, item)
      local selected = picker:selected()
      if #selected == 0 and item then
        selected = { item }
      end
      picker:close()

      -- 4) Chạy song song bằng Overseer (tạo task trực tiếp)
      for _, sel in ipairs(selected) do
        local task = overseer.new_task({
          name = ("task %s"):format(sel.text),
          cmd = { "task" },
          args = { sel.text },
          components = { "default" },
        })
        task:start()
      end

      if #selected > 1 then
        overseer.open()
        vim.notify("Đang chạy " .. #selected .. " task song song.", vim.log.levels.INFO)
      end
    end,
  })
end

vim.keymap.set("n", "<leader>om", run_multiple_overseer_tasks, { desc = "Run Multiple Tasks (Taskfile Picker)" })
