return {
  -- 1. Hiển thị Markdown đẹp mắt (Render)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    ft = { "markdown", "codecompanion" },
  },

  -- 2. Xem trước Markdown trên trình duyệt
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- 3. Cấu hình Format (Dùng conform.nvim thay vì none-ls)
  -- Tôi sử dụng prettier ở đây để tự động căn chỉnh code, bảng biểu...
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Giữ cấu hình cũ của bạn cho markdown
      opts.formatters_by_ft.markdown = { "prettier" }
      -- Thêm xmlformatter cho xml mà không làm mất các ngôn ngữ khác
      opts.formatters_by_ft.xml = { "xmlformatter" }
    end,
  },

  -- 4. LSP Config (Nếu bạn dùng marksman để hỗ trợ link, tag)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {}, -- LSP chuyên dụng cho markdown (nên cài qua Mason)
      },
    },
  },

  -- 5. Vô hiệu hóa linter cho markdown trong nvim-lint
  -- Điều này đảm bảo nvim-lint không tự gọi markdownlint-cli2 nữa
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Xóa cấu hình markdown khỏi linters_by_ft nếu có
      if opts.linters_by_ft then
        opts.linters_by_ft.markdown = nil
      end
    end,
  },
}
