-- FileManager.lua
--

--- @class FileManager
--- @field path string, path where all the timers will be stored.
--- Defaults to: "~/.lucashdez/tasktracker/timers"
local M = {}

local function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- permission denied
			return true
		end
	end
	return ok, err
end

--- Inits the file manager with the path to the timers
--- @param fm_opts table, the custom options for the FileManager
function M.init(fm_opts)
	fm_opts = fm_opts or nil
	if fm_opts == nil then
		M.path = "~/.lucashdez/tasktracker/timers/"
		-- Look if it exists or create it
		if not exists(M.path) then
			os.execute("mkdir -p ~/.lucashdez/tasktracker/timers")
		end
	end
end

function M.read_today() end

return M
