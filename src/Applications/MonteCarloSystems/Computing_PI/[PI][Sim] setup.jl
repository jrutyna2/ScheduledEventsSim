# Interface
#   *  initialize(::Simulation)
#   *  run(::Simulation)

#   *  count(::Collector)
#   *  sum(::Collector)
#   *  mean(::Collector)

### Example  PI Simulation

struct PISim <: MonteCarloSim end

function nextvalue(sim::PISim)
    x  = rand(2)
	( √(x[1]^2 + x[2]^2) < 1 ) ? 1 : 0
end

calcPI(results::Results) = 4 * mean(results)
confintPI(results::Results; level = 0.95) = map(x->4x, confint(results; level))
