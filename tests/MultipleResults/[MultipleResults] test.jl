include("./deps/build.jl")

gatherreesultargs(constant, values; args...) = Results(constant, NamedTuple(args), values, 5)

gatherreesultargs(Sum, 0)
gatherreesultargs(NormalStats, 0)

struct Foo
    fint::Int
    ffloat::Float64
end

struct Bar
    bint::Int
    bfloat::Float64
    bintv::Vector{Int}
end

foo = Foo(5,6.7)
bar = Bar(5,6.7,[50,60,70])

fooResults = gatherreesultargs(Sum, foo)

measurenames(fooResults)
selector(fooResults)
measurements(fooResults)
values(fooResults)

add!(fooResults, foo)


barResults = gatherreesultargs(Sum, bar; bintv = 2)
barResults = gatherreesultargs(Sum, bar; bintv = (1,3))
barResults = gatherreesultargs(Sum, bar; bintv = [1,3])
barResults = gatherreesultargs(Sum, bar; bintv = 2:3)
barResults = gatherreesultargs(Sum, bar; bintv = (NormalStats, 2))
barResults = gatherreesultargs(Sum, bar; bintv = (NormalStats, (1,3)))
barResults = gatherreesultargs(Sum, bar; bintv = (NormalStats, 2:3))

barResults = gatherreesultargs(Sum, bar; bintv = 2, bfloat = NormalStats)
barResults = gatherreesultargs(Sum, bar; bfloat = NormalStats, bintv = (NormalStats, 2:3))
barResults = gatherreesultargs(Sum, bar; bintv = 2, bfloat = NormalStats)

barResults = gatherreesultargs(Skip, bar; bintv = 2)            # badly formed request
barResults = gatherreesultargs(Skip, bar; bintv = (NormalStats, 2))
barResults = gatherreesultargs(Skip, bar; bint = Sum, bintv = (NormalStats, (1,3)))
barResults = gatherreesultargs(Skip, bar; bint = Sum, bintv = (Sum, (1,3)), bfloat = NormalStats)

measurenames(barResults)
selector(barResults)
measurements(barResults)
values(barResults)

add!(barResults, bar)
measurements(barResults)
barResults[:bint]

#-----------------------------------
# Try with a simple simulator with no vector measures

servicetime(sim::SingleServerSystem)      = rand(3:12)
interarrivaltime(sim::SingleServerSystem) = rand(1:8)

sim = SingleServerSystem(end_time = 100)

sss_results = repeat(sim, NormalStats, 30; busy = Skip, queue = Skip)

mean(sss_results)

mean(sss_results[:W_Q])
var(sss_results[:W_Q])
confint(sss_results[:T_idle])


#-----------------------------------
# Try with a more complex simulator with a vector measure

servicetime(sim::MultiServerSystem)      = rand(1:8)
interarrivaltime(sim::MultiServerSystem) = rand(3:12)

sim = MultiServerSystem(servers = 2, end_time = 100)

mss_results = repeat(sim, NormalStats, 30; serving = Skip, queue = Skip, T_S = 1:3);

mean(mss_results[:W_Q])
var(mss_results[:W_Q])

mean(mss_results[:T_S_1])
confint(mss_results[:T_S_1])

mean(mss_results[:T_S_3])
confint(mss_results[:T_S_3])

mean(mss_results[:T_S_2])
confint(mss_results[:T_S_2])

#-----------------------------------
# Test that error is produced when the vector selector is not specified

mss_results = repeat(sim, StoredValues, 30; serving = Skip, queue = Skip);

