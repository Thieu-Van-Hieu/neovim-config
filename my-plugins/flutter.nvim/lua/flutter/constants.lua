local M = {}

M.COMMANDS = {
  CREATE = "flutter create",
  RUN = "flutter run",
  DEVICES = "flutter devices",
  PUB_GET = "flutter pub get",
  CLEAN = "flutter clean",
}

M.FLAGS = {
  TEMPLATE = "--template=",
  PLATFORM = "--platforms=",
  ORG = "--org=",
  PROJECT_NAME = "--project-name=",
  ANDROID_LANG = "--android-language=",
  IOS_LANG = "--ios-language=",
  MACHINE = "--machine",
}

M.PATHS = {
  RUN_CONFIG = vim.fn.stdpath("cache") .. "/flutter/run_config.json",
}

M.URLS = {
  PUB_DEV_PACKAGES_SEARCH = "https://pub.dev/api/search?q=",
}

return M
