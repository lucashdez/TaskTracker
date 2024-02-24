function ttcmd(opts)
	local tt = require("TaskTracker")
	local args = opts["args"]
	if args == "start_timer" then
		tt.start_timer()
	elseif args == "end_timer" then
		print("end_timer")
	elseif args == "resume_timer" then
		print("resume_timer")
	elseif args == "copy_table" then
		print("copy_table")
	elseif args == "table_heading" then
		print("table_heading")
	elseif args == "current_timer" then
		print("current_timer")
		tt.current_timer()
	else
		error("something is wrong", 1)
	end
end

function TaskTrackerCompletion(Args, Cmd, CPos)
	return { "start_timer", "end_timer", "resume_timer", "copy_table", "table_heading", "current_timer" }
end

vim.api.nvim_create_user_command(
	"TaskTracker",
	ttcmd,
	{ desc = "Create a timer", nargs = "*", complete = TaskTrackerCompletion }
)
