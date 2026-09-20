local constants = require("flutter.constants")
local LANGS = require("flutter.enums.language").LANGS
local PLATFORMS = require("flutter.enums.platform").PLATFORMS
local TEMPLATES = require("flutter.enums.template").TEMPLATES

local M = {}

---@class FlutterCreateConfig
---@field name string Tên dự án Flutter
---@field path string Đường dẫn nơi tạo dự án
---@field org string Tên tổ chức (ví dụ: com.example)
---@field template string Loại mẫu dự án (app, package, plugin)
---@field platforms string[] Nền tảng mục tiêu (android, ios, web, windows, macos, linux)
---@field android_language string Ngôn ngữ lập trình cho Android (java, kotlin)
---@field ios_language string Ngôn ngữ lập trình cho iOS (objc, swift)
M.create_config = {
  name = "my_flutter_app",
  path = vim.fn.getcwd(),
  org = "com.example",
  template = TEMPLATES.APP,
  platforms = {
    PLATFORMS.ANDROID,
    PLATFORMS.WINDOWS,
    PLATFORMS.WEB,
  },
  android_language = LANGS.ANDROID.KOTLIN,
  ios_language = LANGS.IOS.SWIFT,
}

---@class FlutterRunConfig
---@field device FlutterDevice|nil Thiết bị đang được chọn (Class Device bạn đã tạo)
---@field mode "debug"|"profile"|"release" Chế độ chạy
---@field flavor string|nil Flavor của ứng dụng (nếu có)
---@field dart_defines table<string, string> Các biến môi trường --dart-define
---@field entry_point string File khởi chạy (thường là lib/main.dart)
M.run_config = {
  device = nil,
  mode = "debug",
  flavor = nil,
  dart_defines = {},
  entry_point = "lib/main.dart",
}

return M
