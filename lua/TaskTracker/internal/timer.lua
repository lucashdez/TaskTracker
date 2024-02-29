--- @class Timer
--- @field name string name of the timer
--- @field stime number the
--- @field etime number the end time of the timer
--- @field active boolean it shows if the timer is active
--- @field internal_timer uv_timer_t the internal timer for the callback
local Timer = {}

function Timer.get_instant(other)
	local instant = os.time()
	return os.date("%H:%M:%S", instant - other.stime)
end

function Timer:get_elapsed()
	local t = self.etime - self.stime
	print(os.date("%H:%M:%S", t))
end

---  @return Timer Timer returns a new timer
function Timer:new(name, stime, internal_timer)
	local o = {}
	setmetatable(o, { __index = self })
	o.name = name
	o.stime = stime
	o.internal_timer = internal_timer
	o.active = true
	return o
end
return Timer
