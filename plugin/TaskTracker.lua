function ttcmd(opts)
	local tt = require("TaskTracker")
	local args = opts["args"]
	if args == "start_timer" then
		tt.start_timer()
	elseif args == "end_timer" then
		tt.end_timer()
	elseif args == "resume_timer" then
		print("resume_timer")
	elseif args == "copy_table" then
		print("copy_table")
	elseif args == "table_heading" then
		print("table_heading")
	elseif args == "current_timer" then
		print("current_timer")
		tt.current_timer()
	elseif args == "get_timers" then
		tt.get_timers()
	else
		local out = ""
		for k, val in pairs(tt) do
			out = out .. tostring(k) .. ":" .. tostring(val) .. "\n"
		end
		print(out)
	end
end

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
end

vim.api.nvim_create_user_command(
	"TaskTracker",
	ttcmd,
	{ desc = "Create a timer", nargs = "*", complete = TaskTrackerCompletion }
)
