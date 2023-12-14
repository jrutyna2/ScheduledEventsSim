startstate(sim::DWWSim)     =  WallessState(sim)

measure(sim::DWWSim)        =  ValueMeasure()
measure(sim::DWWSim, state) =  furthestdistance(state)

steppedleft(sim) = rand() < probleft(sim)

function update!(sim::DWWSim, state)
    state.loc += steppedleft(sim) ? -1 : 1
    state.maxLoc = max( abs( location(state)), furthestdistance(state))
end

function verbose(::☼State☼, sim::DWWSim, state)
    @printf("loc = %3d, \t furthest = %3d", location(state), furthestdistance(state))
end
