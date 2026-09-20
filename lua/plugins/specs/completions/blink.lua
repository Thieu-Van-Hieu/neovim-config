return {
  "saghen/blink.cmp",
  opts = {
    -- 1. BẬT COMMAND MODE (Đây là lý do tại sao nó không gợi ý khi gõ lệnh :)
    cmdline = {
      enabled = true,
      -- Dùng lại keymap chung hoặc định nghĩa riêng cho cmdline ở đây
      keymap = nil,
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
    },

    fuzzy = { implementation = "lua" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    keymap = {
      preset = "none",
      -- Giữ các phím cũ của bạn
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-c>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },

      -- 2. TÍCH HỢP TAB THÔNG MINH (Để dùng chung với Copilot Ghost Text)
      ["<Tab>"] = {
        function(cmp)
          -- Nếu Copilot đang hiện ghost text -> Ưu tiên Accept Copilot trước
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
            return true
          end
          -- Nếu không có Copilot mà menu Blink đang mở -> Chọn cái tiếp theo
          if cmp.is_visible() then
            return cmp.select_next()
          end
        end,
        "fallback", -- Nếu không có gì thì Tab bình thường
      },

      ["<S-Tab>"] = { "select_prev", "fallback" },
      -- Cấu hình ENTER
      ["<CR>"] = { "accept", "snippet_forward", "fallback" },
    },

    snippets = {
      preset = "luasnip",
    },

    appearance = {
      highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
    },
  },
}
