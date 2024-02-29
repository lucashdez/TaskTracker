local ui_utils = require("TaskTracker.internal.ui")
local timing_utils = require("TaskTracker.internal.timer")

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
--- This function finds the timer by its name.
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

function M.current_timer(timer)
	local instant = os.time()
	local timestr = os.date("%H:%M:%S", instant - timer.stime)
	print("Timer " .. timer.name .. " at: " .. timestr)
end

function M.private.start_timer_completion(_, cmd, _)
	local splitCmd = vim.list_slice(
		vim.split(cmd, " ", {
			plain = true,
			trimempty = true,
		}),
		1
	)

	local name_list = {}
	for idx, timer in ipairs(M.session_timers.arr) do
		name_list[idx] = tostring(idx) .. timer.name
	end

	return name_list
end

function M.start_timer()
	M.session_timers.arr[table.maxn(M.session_timers.arr) + 1] = timing_utils:new()
	vim.ui.input({
		prompt = "Task name: ",
		completion = "customlist,v:lua.require('TaskTracker').private.start_timer_completion",
	}, function(args)
		if args == nil then
			return
		end

		local nidx = table.maxn(M.session_timers.arr)

		getmetatable(M.session_timers.arr[nidx]).__index.name = args:gsub("%s+", "")
		getmetatable(M.session_timers.arr[nidx]).__index.stime = os.time()
		getmetatable(M.session_timers.arr[nidx]).__index.active = true
		getmetatable(M.session_timers.arr[nidx]).__index.etime = nil
		getmetatable(M.session_timers.arr[nidx]).__index.internal_timer = vim.loop.new_timer()
		M.tracking = true
		M.private.window = ui_utils.new_window()
		M.private.window.create_timer_window()

		getmetatable(M.session_timers.arr[nidx]).__index.internal_timer.start(
			getmetatable(M.session_timers.arr[nidx]).__index.internal_timer,
			1000,
			1000,
			vim.schedule_wrap(function()
				M.private.window.write_timer(getmetatable(M.session_timers.arr[nidx]).__index)
			end)
		)
	end)
end

return M
