local ui_utils = require("TaskTracker.internal.ui")
local timing_utils = require("TaskTracker.internal.timer")

---@module 'TaskTracker'
local M = {}
M.name = ""
M.tracking = false
M.private = {}
M.private.window = nil

--- @class SessionTimer
--- @field arr Array<Timer> array of timers for the session
M.st = {}
M.st.arr = {}

--- @param name string
--- This function finds the timer by its name.
function M.st.find_timer(name)
	if name == nil then
		return nil
	end
	name = name:gsub("%s+", "")
	for i, t in ipairs(M.st.arr) do
		if t.name == name then
			return i
		end
	end
	return nil
end

--- @return number|nil the index of the active timer of nil
function M.st.active_timer()
	for i, t in ipairs(M.st.arr) do
		if t.active then
			return i
		end
	end
	return nil
end

-- opts is a param
function M.setup(_)
	local time = require("TaskTracker.internal.timer")
end

--- Prints the timers of the current session
function M.get_timers()
	local out = ""
	for i, t in ipairs(M.st.arr) do
		out = out .. tostring(i) .. ": " .. t.name .. "\n"
	end
	print(out)
end

function M.private.start_timer_completion(_, cmd, _)
	local name_list = {}
	for idx, timer in ipairs(M.st.arr) do
		name_list[idx] = timer.name
	end
	return name_list
end

function M.end_timer()
	if M.tracking == false then
		print("No running timer")
		return
	end
	local i = M.st.active_timer()
	M.st.arr[i].etime = os.time()
	M.st.arr[i].active = false
	M.tracking = false
	M.st.arr[i]:get_elapsed()
	M.st.arr[i].internal_timer:stop()
	M.private.window.close_window()
end

--- Starts a new timer and appends it to the session timers
function M.start_timer()
	if M.tracking then
		local i_active = M.st.active_timer()
		local out = "Already counting on: " .. M.st.arr[i_active].name
		print(out)
		return
	end
	vim.ui.input({
		prompt = "Task name: ",
		completion = "customlist,v:lua.require('TaskTracker').private.start_timer_completion",
	}, function(args)
		if args == nil then
			return
		end

		local nidx = table.maxn(M.st.arr) + 1
		M.st.arr[nidx] = timing_utils:new(args:gsub("%s+", ""), os.time(), vim.loop.new_timer())

		M.tracking = true
		M.private.window = ui_utils.new_window()
		M.private.window.create_timer_window()

		M.st.arr[nidx].internal_timer.start(
			M.st.arr[nidx].internal_timer,
			0,
			1000,
			vim.schedule_wrap(function()
				M.private.window.write_timer(M.st.arr[nidx])
			end)
		)
	end)
end

return M
