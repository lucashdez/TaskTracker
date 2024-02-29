local M = {}
--- @class Timer
--- @field name string name of the timer
--- @field stime number the
--- @field etime number the end time of the timer
--- @field active boolean it shows if the timer is active
--- @field internal_timer uv_timer_t the internal timer for the callback
local Timer = {}

--- starts the timer
function Timer.start_timer()
	Timer.stime = os.time()
	print(os.date("%H:%M:%S", Timer.time))
end

function Timer.end_timer()
	Timer.etime = os.time()
	print(os.date("%H:%M:%S", Timer.etime))
end

---  @return Timer Timer returns a new timer
function M.new()
	return Timer
end
return M
