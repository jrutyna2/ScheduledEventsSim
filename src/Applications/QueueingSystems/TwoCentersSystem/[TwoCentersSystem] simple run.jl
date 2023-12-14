###########################################################################
#  Two Center System
###########################################################################
# -------------  [State]  -------------
#  queue::Vector{Int}
#  serving::Vector{Int}
# -------------  [Stats]  -------------
#  N::Int
#  NW::Vector{Int}
#  WQ::Vector{Time}
#  WS::Vector{Time}
#  TS::Vector{Vector{Time}}
#  Tmax::Time                  (Const)
#  IAT::Time
###########################################################################

# -----------------------  [setup simulator]  --------------------------- #
include("../../../../deps/build.jl")

TimeType(sim::TCSystem)         =  Int
endtime(sim::TCSystem)          =  100
interarrivaltime(sim::TCSystem) =  rand(1:8)
distributions(sim::TCSystem)    =  [3:12, 4:8]
servicetime(sim::TCSystem, i)   =  rand(distributions(sim)[i])

sim = TCSystem(c1 = 2, c2 = 1)


# -------------------------  [verbose run]  ----------------------------- #
runsim(sim, verbose = true)


# ----------------------  [run the simulator]  -------------------------- #
results = repeat(sim, 5);
for i = 1:5
    println(resultsTC[i])
end

# ------------------------  [perform stats]  ---------------------------- #
mean(results[:N])

stats_WS = results[:WQ, 1]
mean(stats_WS)
confint(stats_WS)
stats_WS = results[:WQ, 2]
mean(stats_WS)
confint(stats_WS)

stats_TS = @offset (1, 0) results[:TS, 1, 0]
mean(stats_TS)
confint(stats_TS)

stats_TS = @offset (1, 0) results[:TS, 1, 1]
mean(stats_TS)
confint(stats_TS)

stats_TS = @offset (1, 0) results[:TS, 1, 2]
mean(stats_TS)
confint(stats_TS)

stats_TS = @offset (1, 0) results[:TS, 2, 0]
mean(stats_TS)
confint(stats_TS)

stats_TS = @offset (1, 0) results(NormalStats)[:TS, 2, 1]
mean(stats_TS)
confint(stats_TS)

tmax = results(Const)[:Tmax]
value(tmax)

results1 = repeat(sim, 30);
results2 = repeat(sim, 30);
results3 = repeat(sim, 30);

ttest(results1[:WQ, 1], results2[:WQ, 1])

stats1_WQ = results1[:WQ, 1]
stats2_WQ = results2[:WQ, 1]
stats3_WQ = stats1_WQ + stats2_WQ

# equivalent calculations, but rmap() is faster and more memory efficient
stats4_WQ = stats1_WQ * stats2_WQ / stats3_WQ
stats5_WQ = rmap((x,y,z) -> x * y / z, stats1_WQ, stats2_WQ, stats3_WQ)

stats6_WQ = 2 * stats4_WQ

stats_gt = rmap(>, stats1_WQ, stats2_WQ)
gt = r_map(>, stats1_WQ, stats2_WQ)

mean(stats_gt)
confint(stats_gt)

mean(gt)
# confint(gt)                # error: confint a sim only function - works on Results, not Vectors

WQ1_1 = results1[:WQ, 1]
WQ1_2 = results1[:WQ, 2]
println("stats1_WQ: \n", WQ1_1)
println("stats2_WQ: \n", WQ1_2)
println("\n\n\n",typeof(results1))

println("\n\n\n",typeof(results1[:WQ, 1]))

WQ2_1 = results2[:WQ, 1]
WQ2_2 = results2[:WQ, 2]

mean(WQ1_1)
mean(WQ1_2)
mean(WQ2_1)
mean(WQ2_2)

var(WQ1_1)
var(WQ1_2)
var(WQ2_1)
var(WQ2_2)

ftest(WQ1_1, WQ2_1)
ttest(WQ1_1, WQ2_1, equalVar = true)

ftest(WQ1_1, WQ1_2)
ftest(WQ2_1, WQ2_2)
