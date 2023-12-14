###########################################################################
#  Single Server System: SSSimexp,exp
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
TimeType(simEE::SingleServerSystem)         = Float64
endtime(simEE::SingleServerSystem)          = 100
servicetime(sim::SingleServerSystem) = 3 + rand(Exponential(1/0.222))  # Exponential distribution with λ ≈ 0.222, shifted by 3
interarrivaltime(sim::SingleServerSystem) = rand(Exponential(1/0.222))  # Exponential distribution with λ ≈ 0.222

function SSSim_exp_exp(n, verbose)
    simEE = SingleServerSystem()
    runsim(simEE, verbose = verbose)
    return repeat(simEE, n)
end