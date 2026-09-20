local wk = require("which-key")

wk.add({
  -- Nhóm phím tắt Flutter (Prefix <leader>F)
  { "<leader>F", group = "Flutter" },
  { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Run Flutter" },
  { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Hot Restart Flutter" },
  { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Quit Flutter" },
  { "<leader>Fl", "<cmd>FlutterLogToggle<cr>", desc = "Toggle Flutter Logs" },
  { "<leader>FL", "<cmd>FlutterLogClear<cr>", desc = "Clear Flutter Logs" },
  { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Select Flutter Device" },
  { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Select Emulator" },
  { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Toggle Outline (Widget Tree)" },
  { "<leader>Fv", "<cmd>FlutterDevTools<cr>", desc = "Open DevTools (Browser)" },
  { "<leader>Fp", "<cmd>FlutterPubGet<cr>", desc = "Pub Get" },
  { "<leader>FP", "<cmd>FlutterPubUpgrade<cr>", desc = "Pub Upgrade" },
  { "<leader>Fc", "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy Profiler URL" },

  -- Các lệnh liên quan đến UI/Visual
  { "<leader>Fh", "<cmd>FlutterRebind<cr>", desc = "Reload (Hot Reload)" },
  { "<leader>FS", "<cmd>FlutterScreenshot<cr>", desc = "Take Screenshot" },
})
