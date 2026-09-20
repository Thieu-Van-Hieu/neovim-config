-- if true then
--   return {}
-- end

local lua_components = require("utils.plugins.ui.lualine.components")

local copilot_pill = {
  function()
    if vim.bo.filetype == "neo-tree" then
      return ""
    end
    return lua_components.copilot_pill_map[_G.copilot_current_status].icon
  end,
  color = function()
    if vim.bo.filetype == "neo-tree" then
      return nil
    end
    return lua_components.copilot_pill_map[_G.copilot_current_status].style
  end,
  separator = { left = "", right = "" },
  padding = { left = 0, right = 0 },
}

local time_pill = {
  lua_components.get_time_component,
  color = { fg = "#bd93f9", bg = "#383a59", gui = "bold" },
  separator = { left = "", right = "" },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "Mofiqul/dracula.nvim",
    },
    opts = {
      options = {
        theme = "dracula",
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = { "NvimTree" },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000, -- 1 giây, tiết kiệm tài nguyên
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = {
          { "filetype", color = { fg = "#6272a4" } },
          copilot_pill,
          time_pill,
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
}
