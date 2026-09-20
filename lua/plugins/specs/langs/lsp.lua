return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Cấu hình cho TypeScript/JavaScript (giữ nguyên của bạn)
      vtsls = {
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "relative",
              importModuleSpecifierPreference = "relative",
            },
          },
          javascript = {
            preferences = {
              importModuleSpecifier = "relative",
              importModuleSpecifierPreference = "relative",
            },
          },
        },
      },
      -- 🟢 Cấu hình clangd chuẩn cho C/C++ (PlatformIO)
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=never", -- Đổi thành 'never' để tránh tự động thêm include lộn xộn trong code nhúng
          "--completion-style=detailed",
          "--function-arg-placeholders",
          -- 🛠️ Thêm đường dẫn tổng quát để nhận diện TẤT CẢ các bộ biên dịch phần cứng của PlatformIO
          "--query-driver=/**/.platformio/packages/**/bin/*gcc*",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        settings = {},
      },
    },
  },
}
