local M = {}
M.name = ""
M.tracking = false

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
		-- vim.api.nvim_open_win(buffer: integer, enter: boolean, config?: table<string, any>)
		-- -complete=customlist,{func} custom completion, defined via {func}
		M.name = args
		M.stime = os.time()
		M.tracking = true
	end)
end

return M
