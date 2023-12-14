#---------------------------------
# Verbose printing of the Event and State / Stats
#    ☼ = \sun

function verbose(h::☼Header☼, s::MSSystem)
    print("---------------------------------------------------")
    print("---------------------------------------------------")
    println()
    @printf("%s%s %-7s %6s", "[curr]", "[post]", "event", "Δtime")
    @printf("%8s %7s %7s %7s %7s", "IAT", "N", "LQ", "LS", "NW")
    @printf("%7s %7s %10s %7s", "WQ", "WS", "T∀idle", "T∀busy")
    println()
    print("---------------------------------------------------")
    print("---------------------------------------------------")
    println()
end

verbose(::☼Time☼,  sim::MSSystem, currTime)     =  @printf("[%4d]", currTime)

☼preevent(sim::MSSystem, name)        =  @printf("[%4d] %-7s %6d", 0, name, 0)
☼event(sim::MSSystem, name, e::Event) =  @printf("[%4d] %-7s %6d", timestamp(e), name, Δpost(e))

verbose(::☼PreEvent☼, sim::MSSystem)            =  ☼preevent(sim, "before")
verbose(::☼Event☼, sim::MSSystem, e::Arrival)   =  ☼event(sim, "arrival", e)
verbose(::☼Event☼, sim::MSSystem, e::EndEvent)  =  ☼event(sim, "end", e)
verbose(::☼Event☼, sim::MSSystem, e::Departure) =  ☼event(sim, "service", e)

function verbose(::☼State☼, sim::MSSystem, state)
    @printf(" %7d %7d %7d %7s %7d", state.IAT, state.N, state.queue, state.serving, state.NW)
    @printf("%7d %7d %7d %7d", state.WQ, state.WS, state.TS[1], state.TS[end])
end

function verbose(::☼Footer☼, sim::MSSystem)
    print("---------------------------------------------------")
    print("---------------------------------------------------")
    println()
end
