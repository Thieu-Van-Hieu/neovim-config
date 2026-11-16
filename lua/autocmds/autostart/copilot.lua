if vim.g.lite then
  return
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, copilot_utils = pcall(require, "utils.plugins.suggestions.copilot-utils")
    if not ok then
      return
    end
    vim.cmd("Copilot enable", { silent = true })
    copilot_utils.init()
  end,
})
