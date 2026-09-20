return {
  "zbirenbaum/copilot.lua",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = false, -- QUAN TRỌNG: Để ghost text không biến mất khi menu Blink hiện
      keymap = {
        accept = false, -- Bạn đã tự viết logic Tab ở ngoài rồi nên để false ở đây
        next = false, -- Để false để dùng phím <M-]> bạn tự map
        prev = false, -- Để false để dùng phím <M-[> bạn tự map
        dismiss = false,
      },
    },
    panel = { enabled = false },
  },
}
