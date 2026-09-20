return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- 1. ĐỊNH NGHĨA MÀU SẮC (Bạn có thể đổi mã màu HEX tại đây)
    vim.api.nvim_set_hl(0, "Hl1", { fg = "#74c7ec" })
    vim.api.nvim_set_hl(0, "Hl2", { fg = "#89dceb" })
    vim.api.nvim_set_hl(0, "Hl3", { fg = "#94e2d5" })
    vim.api.nvim_set_hl(0, "Hl4", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "Hl5", { fg = "#f9e2af" })
    vim.api.nvim_set_hl(0, "Hl6", { fg = "#fab387" })

    dashboard.section.header.val = {
      [[███╗   ███╗██████╗    ███╗   ██╗ ██████╗ ██████╗  ██████╗ ██████╗ ██╗   ██╗]],
      [[████╗ ████║██╔══██╗   ████╗  ██║██╔═══██╗██╔══██╗██╔═══██╗██╔══██╗╚██╗ ██╔╝]],
      [[██╔████╔██║██████╔╝   ██╔██╗ ██║██║   ██║██████╔╝██║   ██║██║  ██║ ╚████╔╝ ]],
      [[██║╚██╔╝██║██╔══██╗   ██║╚██╗██║██║   ██║██╔══██╗██║   ██║██║  ██║  ╚██╔╝  ]],
      [[██║ ╚═╝ ██║██║  ██║██╗██║ ╚████║╚██████╔╝██████╔╝╚██████╔╝██████╔╝   ██║   ]],
      [[╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═════╝    ╚═╝   ]],
    }

    -- 2. CẤU HÌNH HIGHLIGHT CHO TỪNG DÒNG
    dashboard.section.header.opts.hl = {
      { { "Hl1", 0, -1 } },
      { { "Hl2", 0, -1 } },
      { { "Hl3", 0, -1 } },
      { { "Hl4", 0, -1 } },
      { { "Hl5", 0, -1 } },
      { { "Hl6", 0, -1 } },
    }
    alpha.setup(dashboard.opts)
  end,
}
