vim.api.nvim_create_autocmd({ "User", "LspAttach", "LspDetach" }, {
  pattern = { "CopilotStatusChanged", "*" },
  callback = function()
    local copilot_utils_ok, copilot_utils = pcall(require, "utils.plugins.suggestions.copilot-utils")
    if not copilot_utils_ok then
      return
    end
    _G.copilot_current_status = copilot_utils.get_status()
  end,
})
