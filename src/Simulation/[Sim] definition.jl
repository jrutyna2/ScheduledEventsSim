abstract type Simulation end

abstract type MonteCarloSim <: Simulation end
abstract type StateSim <: Simulation end
abstract type DiscreteEventSim <: StateSim end

const EventSim = DiscreteEventSim
