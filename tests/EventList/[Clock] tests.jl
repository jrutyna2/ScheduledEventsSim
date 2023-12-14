include("./deps/build.jl")

clock = Clock()
time!(clock, 20.2)

clock = Clock(20.2)


clock
time(clock)
prevtime(clock)
Δprev(clock)
ft = futuretime(clock, 10.3)

time!(clock, ft)
