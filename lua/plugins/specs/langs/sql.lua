return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Lựa chọn 1: sqls (Phổ biến, hỗ trợ nhiều tính năng nâng cao)
        sqls = {
          settings = {
            sqls = {
              connections = {
                -- Bạn có thể config sẵn connection ở đây hoặc dùng vimbadbod
              },
            },
          },
        },
        -- Lựa chọn 2: sql_language_server (Đơn giản hơn)
        -- sql_language_server = {},
      },
    },
  },
  {
    "tpope/vim-dadbod",
    optional = true,
    enabled = not vim.g.lite,
    setup = function()
      -- Ghi đè autocmd cũ của LazyVim để không gọi 'cmp'
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          -- Thay vì gọi cmp.setup.buffer như bản cũ,
          -- ta để blink.cmp tự xử lý qua blink.compat hoặc không làm gì cả
          -- (Blink sẽ tự nhận diện qua cấu hình sources)
        end,
      })
    end,
  },
  -- Đảm bảo blink.cmp nhận được nguồn từ Dadbod mà không cần nvim-cmp
  {
    "saghen/blink.cmp",
    optional = true,
    enabled = not vim.g.lite,
    dependencies = { "kristijanhusak/vim-dadbod-completion", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "dadbod" },
        providers = {
          dadbod = {
            name = "Dadbod",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
