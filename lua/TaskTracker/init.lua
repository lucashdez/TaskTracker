local M = {}
M.name = ""
M.tracking = false
M.private = {}

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
	vim.ui.input({
		prompt = "Task name: ",
		completion = "customlist,v:lua.require('TaskTracker').private.start_timer_completion",
	}, function(args)
		-- vim.api.nvim_open_win(buffer: integer, enter: boolean, config?: table<string, any>)
		M.name = args
		M.stime = os.time()
		M.tracking = true
	end)
	local buf = vim.api.nvim_create_buf(false, true)
	local ui = vim.api.nvim_list_uis()[1]
	local col = 12
	if ui ~= nil then
		col = math.max(ui.width - 13, 0)
	end
	local win = vim.api.nvim_open_win(buf, false, {
		relative = "editor",
		width = 40,
		height = 1,
		row = 0,
		col = col,
		border = "rounded",
	})
	vim.api.nvim_buf_set_lines(buf, 1, 1, true, { "A" })
end

return M
