###########################################################################
#  Single Server System: SSSimunif,unif
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
TimeType(simUU::SingleServerSystem)         = Int
endtime(simUU::SingleServerSystem)          = 100
servicetime(simUU::SingleServerSystem)      = rand(3:12)          #STunif Service Time
interarrivaltime(simUU::SingleServerSystem) = rand(1:8)           #IATunif Inter-Arrival Time

function SSSim_unif_unif(n, verbose)
    simUU = SingleServerSystem()
    runsim(simUU, verbose = verbose)
    return repeat(simUU, n)
end

