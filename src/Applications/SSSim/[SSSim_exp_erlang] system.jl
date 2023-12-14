###########################################################################
#  Single Server System: SSSimexp,erlang
###########################################################################
# -------------  [State]  -------------
#  queue::Int
#  busy::Bool
# -------------  [Stats]  -------------
#  N::Int
#  NW::Int
#  WQ::Time
#  WS::Time
#  T_idle::Time                             
#  Tmax::Time               (Const)
#  IAT::Time
###########################################################################

# -----------------------  [setup simulator]  --------------------------- #
TimeType(simEEr::SingleServerSystem)         = Float64
endtime(simEEr::SingleServerSystem)          = 100
servicetime(sim::SingleServerSystem) = rand(Erlang(2, 0.5454))  # Erlang distribution with k=2, λ ≈ 0.5454
interarrivaltime(sim::SingleServerSystem) = rand(Exponential(1/0.222))  # Exponential distribution with λ ≈ 0.222

# Service time using Erlang distribution (STerlang) with k=2 and lambda=0.5454
# servicetime(simEEr::SingleServerSystem)      = sum(ceil(Int, rand(Exponential(0.5454))) for _ in 1:2)

function SSSim_exp_erlang(n, verbose)
    simEEr = SingleServerSystem()
    runsim(simEEr, verbose = verbose)
    return repeat(simEEr, n)
end