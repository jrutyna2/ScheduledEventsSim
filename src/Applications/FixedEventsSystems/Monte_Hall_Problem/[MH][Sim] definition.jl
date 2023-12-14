####################################################
# Monte Hall Simulation Setup

# Strategy switch (through multiple dispatch) for the Monte Hall simulation
abstract type Strategy end
struct Switch <: Strategy end
struct Stay <: Strategy end
struct DoesntMatter <: Strategy end

# Simulation type definition
struct MonteHall <: DiscreteEventSim
    strategy::Strategy
end

# constructor
MonteHall(Strategy::Type) = MonteHall( Strategy())

# accessor
strategy(sim::MonteHall) = sim.strategy

