return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = function(_, opts)
    opts.options.mode = "buffers"
    opts.options.separator_style = ""
    opts.options.offsets = {
      {
        filetype = "nvim-tree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left",
      },
    }
  end,
}
