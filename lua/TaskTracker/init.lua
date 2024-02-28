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
		timer.name = args
		timer.stime = os.time()
		timer.active = true
		timer.etime = nil
		M.name = args
		M.stime = os.time()
		M.tracking = true
	end)
	M.private.window = ui_utils.new_window()
	M.private.window.create_timer_window()
end

return M
