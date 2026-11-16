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
          },

          -- 3. Gán đè phím tắt sử dụng các hàm custom ở trên
          win = {
            input = {
              keys = {
                ["o"] = { "open_in_linux_explorer", mode = { "n" } },
              },
            },
          },
        },
      },
    },
  },
}
