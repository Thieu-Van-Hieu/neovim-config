local wk = require("which-key")

wk.add({
  {
    "<leader>n",
    function()
      Snacks.notifier.show_history()
    end,
    desc = "Show Notification History (Snacks)",
  },
})
