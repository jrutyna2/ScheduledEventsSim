include("../../../../deps/build.jl")

dww = DWWSim()
runsim(dww, verbose = true)
runsim(dww)

# note: measure(:DWWSim, :DWWState) is defined in "[DWW] interface.jl"}
#          - it returns a single value, not a state or a return object
#          - the return value is a calculated measure of the state: furthestdistance(state)
#          - the system therefore defaults to StoredValues
#          - consequently, mean and confit can be called directly on results

results = repeat(dww, 1000)
mean(results)
confint(results)

dww = DWWSim(maxitr = 100)

# You can also no use NormalStats, which would not work if StoredValues, the default, is used
results = repeat(dww, 1000, NormalStats)
mean(results)
confint(results)

