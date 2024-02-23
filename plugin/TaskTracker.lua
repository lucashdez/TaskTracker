vim.api.nvim_create_user_command("TaskTracker", function()
	require("TaskTracker").setup(opts)
end, {})
