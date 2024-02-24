local Timer = {}

function Timer.start_timer()
	Timer.stime = os.time()
	print(os.date("%H:%M:%S", Timer.time))
end

function Timer.end_timer()
	Timer.etime = os.time()
	print(os.date("%H:%M:%S", Timer.etime))
end

return Timer
