#--------------------------------------------
#  Default interface used by WithStateSim for runsim 
maxitr(sim::StateSim)         =  sim.maxitr
isfound(sim::StateSim, state) =  false

measure(sim::StateSim)                         =  StateMeasure()
measure(sim::StateSim, m::ValueMeasure, state) =  measure(sim, state)
measure(sim::StateSim, m::StateMeasure, state) =  state
measure(sim::StateSim, state)                  =  error("When measure is ValueMeasure, measure(sim, state) = value must be defined") 

startstate(sim::StateSim)     =  error("startstate(sim) must be defined by the application")
update!(sim::StateSim, state) =  error("update!(sim, state) must be defined by the application")

