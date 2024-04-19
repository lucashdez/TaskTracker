-- FileManager.lua
-- The structure of the timers file is as follows:
--
-- initTimestamp endTimestamp;NameOfTheTask\n
-- ...

--- @class FileManager
--- @field path string, path where all the timers will be stored.
--- Defaults to: "~/.lucashdez/tasktracker/timers"
--- @field file File, the name of the file opened to save timers to
local M = {}

--- @class File
--- @field name string, name of the opened file
--- @field ptr file*|nil, pointer to the opened file
M.file = {
	ptr = nil,
	name = "",
}

local su = require("TaskTracker.internal.string_utils")
local tu = require("TaskTracker.internal.timer")

local function _exists(file)
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
	if #fm_opts == 0 then
		M.path = "~/.lucashdez/tasktracker/timers/"
		-- Look if it exists or create it
		if not _exists(M.path) then
			os.execute("mkdir -p ~/.lucashdez/tasktracker/timers")
		end
	end
end

local function _file_exists(file)
	local f, err = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

--- Reads a file from a path to get the timers
--- @param file string, the path to the file
--- @return table<Timer> # The table with the timers
function M.read(file)
	local timers = {}
	if _file_exists(file) then
		local lines = {}
		for line in io.lines(file) do
			lines[#lines + 1] = line
		end
		for _, line in pairs(lines) do
			local t = su.split_string(line, ";")
			if t ~= nil then
				local ts = su.split_string(t[0], " ")
				if ts ~= nil then
					timers[#timers + 1] = tu:read(t[1], ts[0], ts[1])
				end
			end
		end
	else
		local name = tostring(os.date("%Y%m%d_%W", os.time()))
		M.file.name = name
		os.execute("touch " .. M.path .. M.file.name .. ".tt")
	end
	return timers
end

--- Reads the file that contains the timers of today
--- @return table<Timer> # The timers of today
--- @return number err The errors for the file
function M.read_today()
	local err = 0
	local ts = os.date("%Y%m%d_%W") .. ".tt"
	local timers = M.read(M.path .. ts)
	if next(timers) == nil then
	end
	return timers, err
end

--- Saves the current timers to the file
function M.save_timers()
	local tt = require("TaskTracker")
	M.file.ptr = assert(io.open(M.path .. M.file.name .. ".tt", "w+"))
	for _, timer in ipairs(tt.st.arr) do
		print(timer)
		local str_save = timer.stime .. " " .. timer.etime .. ";" .. timer.name
		print(str_save)
		M.file.ptr:write(str_save)
	end
	M.file.ptr:flush()
	M.file.ptr:close()
end

return M
