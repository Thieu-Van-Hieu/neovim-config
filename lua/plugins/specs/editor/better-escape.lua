return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      timeout = 200,
      default_mappings = false,
      mappings = {
        i = {
          j = { k = "<Esc>", j = "<Esc>" },
          k = { j = "<Esc>" },
        },
        x = {
          j = { k = "<Esc>" },
          k = { j = "<Esc>" },
        },
        c = {
          j = { k = "<C-c>" },
          k = { j = "<C-c>" },
        },
      },
    })

    -- chỉ áp dụng cho terminal lazygit
    vim.api.nvim_create_autocmd("TermOpen", {
      callback = function()
        local name = vim.api.nvim_buf_get_name(0):lower()
        local ft = vim.bo.filetype

        if not (ft == "snacks_terminal" and name:find("lazygit")) then
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], { buffer = true })
          vim.keymap.set("t", "kj", [[<C-\><C-n>]], { buffer = true })
        end
      end,
    })
  end,
}
