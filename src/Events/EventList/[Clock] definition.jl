import Base.Libc.time

#-----------------------------------
#  Clock type definition

mutable struct Clock{Time}
    time::Time
    prev::Time
end

Clock{Time}(startTime = 0.0) where Time <: Real = Clock{Time}(startTime, startTime)
Clock(startTime = 0.0)                          = Clock{typeof(startTime)}(startTime, startTime)

#-----------------------------------
#  Clock accessors

time(clock::Clock) = clock.time
prevtime(clock::Clock) = clock.prev
Δprev(clock::Clock) = time(clock) - prevtime(clock)
futuretime(clock::Clock, Δtime) = time(clock) + Δtime

function time!(c::Clock, newTime)
    c.prev = c.time
    c.time = newTime
end
