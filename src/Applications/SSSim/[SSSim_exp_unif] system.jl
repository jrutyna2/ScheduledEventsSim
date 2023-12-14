###########################################################################
#  Single Server System: SSSimexp,unif
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
TimeType(simEU::SingleServerSystem)         = Float64
endtime(simEU::SingleServerSystem)          = 100
servicetime(sim::SingleServerSystem) = Float64(rand(3:12))  # Uniform distribution between 3 and 12
interarrivaltime(sim::SingleServerSystem) = rand(Exponential(1/0.222))  # Exponential distribution with λ ≈ 0.222

function SSSim_exp_unif(n, verbose)
    simEU = SingleServerSystem()
    runsim(simEU, verbose = verbose)
    return repeat(simEU, n)
end

