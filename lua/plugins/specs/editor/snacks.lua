return {
  "folke/snacks.nvim",
  opts = {
    image = {
      force = true,
    },
    session = {
      enable = true,
    },
    picker = {
      sources = {
        projects = {
          confirm = "load_session",
          win = {
            input = {
              keys = {
                ["<c-d>"] = { "project_del", mode = { "n", "i" } },
              },
            },
          },
        },
        explorer = {
          -- 1. Cấu hình hiển thị / bộ lọc file từ file editor cũ
          exclude = {
            "node_modules",
            ".git",
            ".idea",
            "dist",
            "**/*.g.dart",
            "**/*.mapper.dart",
            "**/*.freezed.dart",
          },
          ignored = false,
          hidden = false,

          -- 2. Định nghĩa các hành động (actions) tùy chỉnh
          actions = {
            open_in_linux_explorer = function(picker)
              local item = picker:current()
              if item and item.file then
                local dir = vim.fs.dirname(item.file)
                vim.fn.jobstart({ "xdg-open", dir }, { detach = true })
              else
                vim.notify("Không tìm thấy đường dẫn hợp lệ.", vim.log.levels.WARN)
              end
            end,

            -- Đổi cwd hệ thống sau khi focus vào sâu hơn
            custom_focus = function(picker)
              picker:execute("explorer_focus") -- Chạy hàm gốc để update view trước
              -- Sửa lỗi: Lấy cwd ngay sau khi picker cập nhật trạng thái ở loop tiếp theo
              vim.schedule(function()
                local current_cwd = picker:cwd()
                if current_cwd then
                  vim.fn.chdir(current_cwd) -- Đồng bộ cwd toàn cục của Neovim
                  vim.notify("Đổi cwd hệ thống sang: " .. current_cwd, vim.log.levels.INFO)
                end
              end)
            end,

            -- Đổi cwd hệ thống sau khi nhảy ra thư mục cha
            custom_up = function(picker)
              picker:execute("explorer_up") -- Chạy hàm gốc để nhảy ra ngoài trước
              -- Sửa lỗi: Đưa vào vim.schedule để tránh việc lấy giá trị cũ trước khi picker kịp render lại
              vim.schedule(function()
                local current_cwd = picker:cwd()
                if current_cwd then
                  vim.fn.chdir(current_cwd) -- Đồng bộ cwd toàn cục của Neovim
                  vim.notify("Đổi cwd hệ thống sang: " .. current_cwd, vim.log.levels.INFO)
                end
              end)
            end,
          },

          -- 3. Gán đè phím tắt sử dụng các hàm custom ở trên
          win = {
            input = {
              keys = {
                ["o"] = { "open_in_linux_explorer", mode = { "n" } },
                ["."] = { "custom_focus", mode = { "n" } },
                ["<BS>"] = { "custom_up", mode = { "n" } },
              },
            },
          },
        },
      },
    },
  },
}
