--- @param tbl table The input table to be mapped.
--- @param fn function The mapping function that takes value, key, and the original table as arguments.
--- @return table A new table with the mapped values.
local function map(tbl, fn)
	local new_tbl = {}
	for k, v in pairs(tbl) do
		new_tbl[k] = fn(v, k, tbl)
	end
	return new_tbl
end

return {
	map = map,
}
