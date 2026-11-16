return {
  "LazyVim/LazyVim",
  keys = {
    {
      "<C-Left>",
      [[<C-\><C-n>:vertical resize +5<CR>i]],
      mode = "t",
      desc = "Giãn rộng khung chat",
    },
    {
      "<C-Right>",
      [[<C-\><C-n>:vertical resize -5<CR>i]],
      mode = "t",
      desc = "Thu hẹp khung chat",
    },
    {
      "<C-Left>",
      [[:vertical resize +5]],
      mode = "n",
      desc = "Giãn rộng khung chat",
    },
    {
      "<C-Right>",
      [[:vertical resize -5]],
      mode = "n",
      desc = "Thu hẹp khung chat",
    },
  },
}
