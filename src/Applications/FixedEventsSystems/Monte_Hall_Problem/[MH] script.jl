include("../../../../deps/build.jl")

mh = MonteHall(DoesntMatter)
runsim(mh; verbose = true)
runsim(mh)

doesntMatter =  repeat(MonteHall(DoesntMatter), 1000, NormalStats)
stay         =  repeat(MonteHall(Stay), 1000, NormalStats)
switch       =  repeat(MonteHall(Switch), 1000, NormalStats)

mean(doesntMatter)
mean(stay)
mean(switch)

confint(doesntMatter)
confint(stay)
confint(switch)
