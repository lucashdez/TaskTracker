local M = {}
M.name = ""
M.tracking = false
M.private = {}

function M.setup(opts)
	local time = require("TaskTracker.internal.timer")
end

function M.current_timer()
	local instant = os.time()
	local timestr = os.date("%H:%M:%S", instant - M.stime)
	print("Timer " .. M.name .. " at: " .. timestr)
end

function M.private.start_timer_completion(_, cmd, _)
	local splitCmd = vim.split(cmd, " ")
	local list = { M.name }
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
	local win = vim.api.nvim_open_win(buf, false, {
		width = 40,
		height = 1,
		row = 1,
		col = 1,
	})
	vim.api.nvim_buf_set_lines(buf, 1, 1, true, { "A" })
end

return M
