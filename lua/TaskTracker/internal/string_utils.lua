--- @module 'internal.string_utils'
local M = {}

function M.fit_string(str, width)
	if #str >= width then
		return str:sub(0, width - 4) .. "... "
	else
		local spaces = width - #str
		local fullstr = str
		for _ = 1, spaces do
			fullstr = fullstr .. " "
		end
		return fullstr
	end
end

function M.split_string(str, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for s in string.gmatch(str, "([^" .. sep .. "]+)") do
		table.insert(t, s)
	end
end

return M
