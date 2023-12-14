include("../../../../deps/build.jl")

piSim = PISim()

results = repeat(piSim, 1000000)
calcPI(results)

results = repeat(piSim, 1000000, Sum)
calcPI(results)

results = repeat(piSim, 1000000, NormalStats)
calcPI(results)

results = repeat(piSim, 1000000, StoredValues)
calcPI(results)

results = repeat(piSim, 1000000, BinomialStats)
results = repeat(piSim, 100000000, BinomialStats)
calcPI(results)
confintPI(results)
confintPI(results; level = 0.99)