local wk = require("which-key")

wk.add({
  {
    "<leader>/",
    "gcc", -- Ở mode Normal, nó sẽ thực hiện lệnh gcc
    desc = "Comment Line",
    mode = "n",
    remap = true, -- Cực kỳ quan trọng: Để nó hiểu "gcc" là một lệnh để thực hiện
  },
  {
    "<leader>/",
    "gc", -- Ở mode Visual, nó thực hiện gc
    desc = "Comment Selection",
    mode = "v",
    remap = true,
  },
})
