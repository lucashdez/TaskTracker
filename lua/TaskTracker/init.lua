local M = {}
M.name = ""

function M.setup(opts)
	local time = require("TaskTracker.internal.timer")
end

function M.current_timer()
	local instant = os.time()
	local timestr = os.date("%H:%M:%S", instant - M.stime)
	print("Timer " .. M.name .. " at: " .. timestr)
end

function M.start_timer()
	vim.ui.input({
		prompt = "Task name: ",
	}, function(args)
		M.name = args
		M.stime = os.time()
	end)
end

return M
