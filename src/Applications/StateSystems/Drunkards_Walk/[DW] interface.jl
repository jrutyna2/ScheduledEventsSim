#----------------------------------------------------------------
# Base interface setup

startstate(sim::DrunkardsWalkSim) = DrunkardsState(sim)

steppedleft(sim) = rand() < probleft(sim)

function update!(sim::DrunkardsWalkSim, state)
    state.loc   +=  steppedleft(sim) ? -1 : 1
    state.steps +=  1
end

isfound(sim::DrunkardsWalkSim, state) = abs(location(state)) >= walls(sim)


#----------------------------------------------------------------
# Measures

atleft(state)  =  closestwall(state) === :left  ? 1 : 0
atright(state) =  closestwall(state) === :right ? 1 : 0

measure(sim::DWSim)                           =  sim.dwmeasure
measure(sim::DWSim, m::StepsMeasure, state)   =  steps(state)
measure(sim::DWSim, m::AtLeftMeasure, state)  =  atleft(state)
measure(sim::DWSim, m::AtRightMeasure, state) =  atright(state)
measure(sim::DWSim, m::StateMeasure, state)   =  state
measure(sim::DWSim, m::DWMeasures, state)     =  DWRecord(steps(state), atleft(state), atright(state))


#----------------------------------------------------------------
# Displaying State - for verbose

function verbose(::☼State☼, sim::DWSim, state)
    @printf("[%2d]  %3d |    %3d    | %3d", steps(state), -walls(sim), location(state), walls(sim))
end
