-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local module_utils = require("utils.common.module-utils")
local modules = {
  "autocmds",
  "settings",
  "keymaps/systems",
}
module_utils.require_all_modules(modules)
