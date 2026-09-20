local module_utils = require("utils.common.module-utils")
local table_utils = require("utils.common.table-utils")
local module_names = module_utils.scan_module_names("plugins/specs", function(_, module_name)
  return string.find(module_name, "self-config") == nil
end)
return table_utils.map(module_names, function(module_name)
  return { import = module_name }
end)
