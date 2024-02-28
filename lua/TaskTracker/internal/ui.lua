--- @module 'Window'
local M = {}

--- @class Window
--- @field id number window id
--- @field buf number buffer id
--- @field closing boolean window is closing
local Window = {}
Window.id = nil
Window.buf = nil
Window.closing = false

--- @param win_opts object
local function create_window(win_opts)
	if Window.id or Window.buf then
		print("window already exists")
	else
		Window.buf = vim.api.nvim_create_buf(false, true)
		Window.win = vim.api.nvim_open_win(Window.buf, false, win_opts)
	end
end

function Window.create_timer_window()
	local ui = vim.api.nvim_list_uis()[1]
	local col = 12
	if ui ~= nil then
		col = math.max(ui.width - 13, 0)
	end
	local options = {
		relative = "editor",
		width = 40,
		height = 1,
		row = 0,
		col = col,
		border = "rounded",
	}
	create_window(options)
end

function M.new_window()
	return Window
end

return M
