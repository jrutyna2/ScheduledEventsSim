###########################################################################
#  Single Server System: SSSimexp,gamma
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
TimeType(simEG::SingleServerSystem)         = Float64
endtime(simEG::SingleServerSystem)          = 100
servicetime(sim::SingleServerSystem) = rand(Gamma(6.82, 1/0.909))  # Gamma distribution with α ≈ 6.82, β ≈ 0.909
interarrivaltime(sim::SingleServerSystem) = rand(Exponential(1/0.222))  # Exponential distribution with λ ≈ 0.222

function SSSim_exp_gamma(n, verbose)
    simEG = SingleServerSystem()
    runsim(simEG, verbose = verbose)
    return repeat(simEG, n)
end