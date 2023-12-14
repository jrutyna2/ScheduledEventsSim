include("./deps/build.jl")

gatherreesultargs(constant, values; args...) = Results(constant, NamedTuple(args), values, 5)

gatherreesultargs(Sum, 0)
gatherreesultargs(NormalStats, 0)

#--------------------------------------------------
struct Foo
    fint::Int
    ffloat::Float64
end

foo = Foo(5, 6.7)

fooResults = gatherreesultargs(Sum, foo)

measurenames(fooResults)
selector(fooResults)
measurements(fooResults)
values(fooResults)

add!(fooResults, foo)

#--------------------------------------------------
struct Bar
    bint::Int
    bfloat::Float64
    bvint::Vector{Int}
end

bar = Bar(5, 6.7, [50,60,70])

barResults = gatherreesultargs(Sum, bar; bvint = 2)
barResults = gatherreesultargs(Sum, bar; bvint = (1,3))
barResults = gatherreesultargs(Sum, bar; bvint = [1,3])
barResults = gatherreesultargs(Sum, bar; bvint = 2:3)
barResults = gatherreesultargs(Sum, bar; bvint = (NormalStats, 2))
barResults = gatherreesultargs(Sum, bar; bvint = (NormalStats, (1,3)))
barResults = gatherreesultargs(Sum, bar; bvint = (NormalStats, 2:3))

barResults = gatherreesultargs(Sum, bar; bvint = 2, bfloat = NormalStats)
barResults = gatherreesultargs(Sum, bar; bfloat = NormalStats, bvint = (NormalStats, 2:3))

barResults = gatherreesultargs(Skip, bar; bvint = 2)            # badly formed request
barResults = gatherreesultargs(Skip, bar; bvint = (NormalStats, 2))
barResults = gatherreesultargs(Skip, bar; bint = Sum, bvint = (NormalStats, (1,3)))
barResults = gatherreesultargs(Skip, bar; bint = Sum, bvint = (Sum, (1,3)), bfloat = NormalStats)

measurenames(barResults)
selector(barResults)
measurements(barResults)
values(barResults)

add!(barResults, bar)
measurements(barResults)
barResults[:bint]
barResults[:bvint1]

#--------------------------------------------------

struct Baz
    zint::Int
    zfloat::Float64
    zvint::Vector{Int}
    zvvfloat::Vector{Vector{Float64}}
end

baz = Baz(5, 6.7, [50,60,70], [[5.5,6.6,7.7], [1.1, 2.2, 3.3]])

zvvfloat_format = ArgFormat(dim_format = (:c, (number, 0)), 
                            indices = (⨉(1, 0:2), ⨉(2, (0, 2))))

bazResults = gatherreesultargs(Sum, baz; zvint = (NormalStats, (1,3)), zvvfloat = zvvfloat_format)

selector(bazResults)
measurements(bazResults)

add!(bazResults, baz)
measurements(bazResults)

zvvfloat_format = ArgFormat(dim_format = (:c, (number, 0)), 
                            indices = ⨉((1,2), 0:2))

bazResults = gatherreesultargs(Sum, baz; zvint = (NormalStats, (1,3)), zvvfloat = zvvfloat_format)

zvvfloat_format = ArgFormat(dim_format = (:c, (number, 0)), 
                            indices = ⨉(1:2, 0:2))

bazResults = gatherreesultargs(Sum, baz; zvint = (NormalStats, (1,3)), zvvfloat = zvvfloat_format)

############################
# Single Server System
############################
#----------[State]---------
#  queue::Int
#  busy::Bool
#----------[Stats]---------
#  N::Int
#  NW::Int
#  WQ::Time
#  WS::Time
#  T_idle::Time
#  Tmax::Time
#  IAT::Time
#  iatime::Time
#  stime::Time
#---------------------------

servicetime(sim::SingleServerSystem)      = rand(3:12)
interarrivaltime(sim::SingleServerSystem) = rand(1:8)

sim = SingleServerSystem(end_time = 100)

sss_results = repeat(sim, NormalStats, 30; busy = Skip, queue = Skip);

mean(sss_results[:WQ])
var(sss_results[:WQ])
confint(sss_results[:T_idle])

mean(sss_results[:Tmax])


############################
# Multiple Server System
############################
#----------[State]---------
#  queue::Int
#  serving::Int
#----------[Stats]---------
#  N::Int
#  NW::Int
#  WQ::Time
#  WS::Time
#  TS::Vector{Time}
#  Tmax::Time
#  IAT::Time
#  iatime::Time
#  stime::Time
#---------------------------

servicetime(sim::MultiServerSystem)      = rand(1:8)
interarrivaltime(sim::MultiServerSystem) = rand(3:12)

sim = MultiServerSystem(servers = 2, end_time = 100)

ts_format = ArgFormat(dim_format = onearg(number, 0), indices = 0:2)

mss_results = repeat(sim, NormalStats, 30; serving = Skip, queue = Skip, TS = ts_format);

mean(mss_results[:WQ])
var(mss_results[:WQ])

mean(mss_results[:TS_0])
confint(mss_results[:TS_0])

mean(mss_results[:TS_1])
confint(mss_results[:TS_1])

mean(mss_results[:TS_2])
confint(mss_results[:TS_2])

mean(mss_results[:Tmax])

############################
# Two Center System
############################
#----------[State]---------
#  queue::Vector{Int}
#  serving::Vector{Int}
#----------[Stats]---------
#  N::Int
#  NW::Vector{Int}
#  WQ::Vector{Time}
#  WS::Vector{Time}
#  TS::Vector{Vector{Time}}
#  Tmax::Time
#  IAT::Time
#  iatime::Time
#  stime::Vector{Time}
#---------------------------

#---------------------------
# Helper functions 
#    - load before running the rest of the script
#---------------------------

measure(argName::Symbol, i)    = Symbol(String(argName) * "_c" * string(i))
measure(argName::Symbol, i, j) = Symbol(String(argName) * "_c" * string(i) * "_" * string(j))

const msr = measure

#-------

interarrivaltime(sim::TCSystem) = rand(1:8)
distributions(sim::TCSystem) = [3:12, 4:8]
servicetime(sim::TCSystem, i)   = rand(distributions(sim)[i])

sim = TCSystem(c1 = 2, c2 = 1, end_time = 100)

c_format = ArgFormat(dim_format = :c, indices = 1:2)
TS_format = ArgFormat(dim_format = (:c, (number, 0)), indices = (⨉(1, 0:2), ⨉(2, 0:1)))    # note: ⨉ is \bigtimes, not the letter x

arg_formats = (serving = Skip,  queue = Skip, Tmax = Sum,
               NW  = c_format,  stime = c_format,
               WQ  = c_format,    WS  = c_format, 
               TS  = TS_format)

results = repeat(sim, NormalStats, 30; arg_formats...);

mean(results[:N])

mean(results[msr(:WQ, 1)])
confint(results[msr(:WQ, 1)])
mean(results[msr(:WQ, 2)])
confint(results[msr(:WQ, 2)])

mean(results[msr(:TS, 1, 0)])
confint(results[msr(:TS, 1, 0)])
mean(results[msr(:TS, 1, 1)])
confint(results[msr(:TS, 1, 1)])
mean(results[msr(:TS, 1, 2)])
confint(results[msr(:TS, 1, 2)])
mean(results[msr(:TS, 2, 0)])
confint(results[msr(:TS, 2, 0)])
mean(results[msr(:TS, 2, 1)])
confint(results[msr(:TS, 2, 1)])

mean(results[:TS_3])
confint(results[:TS_3])

mean(results[:TS_2])
confint(results[:TS_2])

mean(results[:Tmax])
