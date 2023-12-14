#-----------------------------------------------------------------
# Measure Type
#-----------------------------------------------------------------

struct StepsMeasure   <: Measure end
struct AtLeftMeasure  <: Measure end
struct AtRightMeasure <: Measure end
struct DWMeasures     <: Measure end

struct DWRecord
    steps::Int
    atleft::Int
    atright::Int
end

# constructor
function DWMeasure(m::Symbol)
    (m === :steps)     && return StepsMeasure()
    (m === :leftwall)  && return AtLeftMeasure()
    (m === :rightwall) && return AtRightMeasure()
    (m === :all)       && return DWMeasures()
    (m === :state)     && return StateMeasure()
    error("measure = $m; it must be one of (:steps, :leftwall, :rightwall, :all, :state)")
end


#-----------------------------------------------------------------
# Simulation Type
#-----------------------------------------------------------------

struct DrunkardsWalkSim{M} <: StateSim
    maxitr::Int
    wallLoc::Int
    startPos::Int
    probLeft::Float64
    dwmeasure::M
end

const DWSim = DrunkardsWalkSim

# constructor
function DrunkardsWalkSim(; walls=10, start=0, prob_left=0.5, prob_right=0.5, measure=:all, maxitr=1000000) 
    abs(start) >= walls && error("Drunkard must start between walls; walls = [-$walls, $walls] and start = $start")
    ( prob_left == 0.5 != prob_right )                 &&  (prob_left = 1 - prob_right)
    ( prob_left != 1 - prob_right && prob_right != 0.5 ) &&  error("prob_left != 1 - prob_right; prob_left = $prob_left, prob_right = $prob_right")
    DrunkardsWalkSim(maxitr, walls, start, prob_left, DWMeasure(measure))
end

# accessors
probleft(sim::DWSim)  = sim.probLeft
probright(sim::DWSim) = 1 - probleft(sim)
walls(sim::DWSim)     = sim.wallLoc
start(sim::DWSim)     = sim.startPos


#-----------------------------------------------------------------
# State Type
#-----------------------------------------------------------------
import Distributions.location

mutable struct DrunkardsState <: State 
    loc::Int
    steps::Int
end

const DWState = DrunkardsState

# constructor
DrunkardsState(sim::DrunkardsWalkSim) = DrunkardsState(start(sim), 0)

# accessors
location(state::DWState)    = state.loc
steps(state::DWState)       = state.steps

closestwall(state::DWState) = (location(state) < 0 ? :left  : 
                               location(state) > 0 ? :right : :neither )
