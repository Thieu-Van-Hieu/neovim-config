local M = {}

-- Blink cần hàm này để khởi tạo Provider
function M.new()
  return setmetatable({}, { __index = M })
end

-- Hàm thực hiện gợi ý
function M:get_completions(context, resolve)
  -- Chỉ chạy trong file pubspec.yaml
  if vim.fn.expand("%:t") ~= "pubspec.yaml" then
    return resolve()
  end

  -- Lấy từ hiện tại đang gõ (query)
  local query = context.line:sub(1, context.cursor[2]):match("[%w_]+$") or ""
  if #query < 2 then
    return resolve()
  end

  local url = "https://pub.dev/api/search?q=" .. query

  -- Dùng vim.system (Async)
  vim.system({ "curl", "-s", "-L", url }, { text = true }, function(obj)
    if obj.code ~= 0 then
      return resolve()
    end

    local ok, decoded = pcall(vim.json.decode, obj.stdout)
    if not ok or not decoded.packages then
      return resolve()
    end

    local items = {}
    for _, p in ipairs(decoded.packages) do
      table.insert(items, {
        label = p.package,
        kind = vim.lsp.protocol.CompletionItemKind.Module,
        insertText = p.package .. ": ^",
        detail = "📦 Pub.dev",
      })
    end

    resolve({
      is_incomplete = true,
      items = items,
    })
  end)
end

-- Đảm bảo các hàm cũ của bạn vẫn hoạt động bình thường bên dưới
function M.create_project(config)
  -- code cũ của bạn...
end

return M
