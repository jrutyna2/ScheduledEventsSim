#-----------------------------------------------------------------
# Simulation Type
#-----------------------------------------------------------------

struct DrunkardsWallessWalkSim <: StateSim
    maxitr::Int
    probLeft::Float64
end

const DWWSim = DrunkardsWallessWalkSim

# contructor
function DrunkardsWallessWalkSim(; prob_left=0.5, prob_right= 1 - prob_left, maxitr=50) 
    prob_left != 1 - prob_right  &&  prob_left == 0.5  &&  (prob_left = 1 - prob_right)
    prob_left != 1 - prob_right  &&  error("prob_left != 1 - prob_right; prob_left = $prob_left, prob_right = $prob_right")
    DrunkardsWallessWalkSim(maxitr, prob_left)
end

# accessors
probleft(sim::DWWSim)  = sim.probLeft
probright(sim::DWWSim) = 1 - probleft(sim)


#-----------------------------------------------------------------
# State Type
#-----------------------------------------------------------------
import Distributions.location

mutable struct WallessState <: State 
    loc::Int
    maxLoc::Int
end

# constructor
WallessState(sim::DWWSim) = WallessState(0, 0)

# accessors
location(state::WallessState)         = state.loc
furthestdistance(state::WallessState) = state.maxLoc
