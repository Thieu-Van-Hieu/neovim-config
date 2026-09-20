--- @param directory string | table<string> Relative directory path to scan for Lua files.
--- @param filter_callback nil | fun(directory: string, module_name: string): boolean A callback function to filter module names.
--- @return table A table containing the names of Lua files in the directory.
local function scan_module_names(directory, filter_callback)
  local module_names = {}

  local config_path = vim.fn.stdpath("config") .. "/lua/"

  if type(directory) == "string" then
    directory = { directory }
  end

  for _, dir in ipairs(directory) do
    local full_directory = config_path .. dir

    local files = vim.fn.glob(full_directory .. "/**/*.lua", true, true)

    for _, file in ipairs(files) do
      local normalize_path = file:gsub("\\", "/") -- Normalize Windows paths
      local relative_path = normalize_path:match("lua/(.+)%.lua$") -- Extract relative path
      local module_name = relative_path:gsub("lua/", ""):gsub("/", ".") -- Convert to module name

      if filter_callback == nil or filter_callback(full_directory, module_name) then
        local ok, _ = pcall(require, module_name)
        if ok then
          table.insert(module_names, module_name)
        end
      end
    end
  end

  return module_names
end

--- @param directory string | table<string> Relative directory path to require all Lua modules from.
--- @param filter_callback nil | fun(directory: string, module_name: string): boolean A callback function to filter module names.
-- This function requires all Lua modules found in the specified directory.
local function require_all_modules(directory, filter_callback)
  local module_names = scan_module_names(directory, filter_callback)
  for _, module_name in ipairs(module_names) do
    require(module_name)
  end
end

return {
  scan_module_names = scan_module_names,
  require_all_modules = require_all_modules,
}
