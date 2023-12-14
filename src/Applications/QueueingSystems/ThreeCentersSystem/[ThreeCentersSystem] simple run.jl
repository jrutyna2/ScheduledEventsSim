###########################################################################
#  Three Center System
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
#  routing_decision::Int
###########################################################################

# -----------------------  [setup simulator]  --------------------------- #
include("../../../../deps/build.jl")
include("[ThreeCentersSystem] system.jl")
TimeType(sim::TRCSystem) = Float64              # Define the type of time used in the simulation
endtime(sim::TRCSystem) = sim.endTime       # Define the simulation end time
interarrivaltime(sim::TRCSystem) = rand(Exponential(1 / sim.lambda_a))  # Define iat based on exponential distribution
servicetime(sim::TRCSystem, i) = rand(Erlang(sim.k[i], sim.lambda_s[i]))# Define st for each center based on Erlang distribution

#initialize the simulation
sim = TRCSystem(lambda_a = 0.5, lambda_s = [1.0, 1.5, 2.0], k = [2, 3, 4], end_time = 100, c1 = 2, c2 = 1, c3 = 1, pchoice = 0.5)

# -------------------------  [verbose run]  ----------------------------- #
runsim(sim, verbose = false)
# ----------------------  [run the simulator]  -------------------------- #
results = repeat(sim, 5);

for i = 1:5
    println(results[i])
end
