local M = {}

-- Enum cho các lệnh PlatformIO phổ biến
M.COMMANDS = {
  BUILD = "pio run",
  UPLOAD = "pio run -t upload",
  UPLOAD_FS = "pio run -t uploadfs",
  MONITOR = "pio device monitor",
  COMPILE_DB = "pio run -t compiledb",
  INIT_VIM = "pio project init --ide vim",
  LIST_BOARDS = { "pio", "boards", "--json-output" },
  LIST_PORTS = { "pio", "device", "list", "--json-output" },
  LIST_LIBS = { "pio", "pkg", "list", "--json-output" },
}

-- Các flag tùy chọn
M.FLAGS = {
  PORT = "--port",
  UPLOAD_PORT = "--upload-port",
  BAUD = "--baud",
  BOARD = "--board",
}

---@enum PioCacheEnum
M.CACHES = {
  BOARDS = "BOARDS_CACHE",
  LIBS = "LIBS_CACHE",
}

M.PATHS = {
  PROJECT_CONFIG = "platformio.ini",
  [M.CACHES.BOARDS] = vim.fn.stdpath("cache") .. "/platformio/boards/cache.json",
  [M.CACHES.LIBS] = vim.fn.stdpath("cache") .. "/platformio/libs/cache.json",
}

return M
