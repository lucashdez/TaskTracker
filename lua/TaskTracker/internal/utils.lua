--- @module 'internal.utils'
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

return M
