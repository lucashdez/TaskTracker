local ui_utils = require("TaskTracker.internal.ui")

---@module 'TaskTracker'
local M = {}
M.name = ""
M.tracking = false
M.private = {}
M.private.window = nil

--- @class SessionTimers
--- @field arr Array<Timer> array of timers for the session
M.session_timers = {}
M.session_timers.arr = {}

--- @param name string
function M.session_timers.find_timer(name)
	if name == nil then
		return nil
	end
	name = name:gsub("%s+", "")
	for i, t in ipairs(M.session_timers.arr) do
		if t.name == name then
			return i
		end
	end
	return nil
end

-- opts is a param
function M.setup(_)
	local time = require("TaskTracker.internal.timer")
end

function M.current_timer()
	local instant = os.time()
	local timestr = os.date("%H:%M:%S", instant - M.stime)
	print("Timer " .. M.name .. " at: " .. timestr)
end

function M.private.start_timer_completion(_, cmd, _)
	local splitCmd = vim.split(cmd, " ")
	local list = {}
	if M.session_timers.arr ~= nil then
		for timer in M.session_timers.arr do
			list[#list + 1] = timer.name
		end
	end
	return vim.tbl_filter(function(key)
		return key:find(splitCmd[#splitCmd])
	end, list)
end

function M.start_timer()
	local timer = {}
	vim.ui.input({
		prompt = "Task name: ",
		completion = "customlist,v:lua.require('TaskTracker').private.start_timer_completion",
	}, function(args)
		timer.name = args:gsub("%s+", "")
		timer.stime = os.time()
		timer.active = true
		timer.etime = nil
		timer.internal_timer = vim.loop.new_timer()

		timer.internal_timer.start(timer.internal_timer, 1000, 0, function() end)
		M.name = args
		M.stime = os.time()
		M.tracking = true
		M.private.window = ui_utils.new_window()
		M.private.window.create_timer_window()
		M.session_timers.arr[#M.session_timers.arr + 1] = timer
	end)
end

return M
