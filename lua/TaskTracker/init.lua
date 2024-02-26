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
		completion = "customList",
	}, function(args)
		-- vim.api.nvim_open_win(buffer: integer, enter: boolean, config?: table<string, any>)
		-- -complete=customlist,{func} custom completion, defined via {func}
		--[[
		function TaskTrackerCompletion(args, cmd, cpos)
			local tt = require("TaskTracker")
			local splitCmd = vim.split(cmd, " ")
			local completions = {}
			for k, t in pairs(tt) do
				if type(t) == "function" then
					table.insert(completions, tostring(k))
				end
			end
			return vim.tbl_filter(function(key)
				return key:find(splitCmd[#splitCmd])
			end, completions)
		end]]
		M.name = args
		M.stime = os.time()
		M.tracking = true
	end)
end

return M
