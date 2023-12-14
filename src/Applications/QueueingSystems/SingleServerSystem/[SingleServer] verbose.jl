#---------------------------------
# Verbose printing of the Event and State / Stats
#    ☼ = \sun

function verbose(h::☼Header☼, s::SSSystem)
    print("---------------------------------------------")
    print("---------------------------------------------")
    println()
    @printf("%s%s ", "[curr]", "[post]")
    @printf("%-7s %6s %6s %7s %7s %7s ", "event", "Δtime", "IAT", "N", "LQ", "busy")
    @printf("%7s %6s %7s %7s", "NW", "WQ", "WS", "T_idle")
    println()
    print("---------------------------------------------")
    print("---------------------------------------------")
    println()
end

verbose(::☼Time☼,  sim::SSSystem, currTime)     =  @printf("[%4d]", currTime)

☼preevent(sim::SSSystem, name)        =  @printf("[%4d] %-7s %6d", 0, name, 0)
☼event(sim::SSSystem, name, e::Event) =  @printf("[%4d] %-7s %6d", timestamp(e), name, Δpost(e))

verbose(::☼PreEvent☼, sim::SSSystem)            =  ☼preevent(sim, "before")
verbose(::☼Event☼, sim::SSSystem, e::Arrival)   =  ☼event(sim, "arrival", e)
verbose(::☼Event☼, sim::SSSystem, e::EndEvent)  =  ☼event(sim, "end", e)
verbose(::☼Event☼, sim::SSSystem, e::Departure) =  ☼event(sim, "service", e)

function verbose(::☼State☼, sim::SSSystem, state)
    @printf("%7d %7d %7d %7s %7d", state.IAT, state.N, state.queue, string(state.busy), state.NW)
    @printf("%7d %7d %7d", state.WQ, state.WS, state.T_idle)
end

function verbose(::☼Footer☼, sim::SSSystem)
    print("---------------------------------------------")
    print("---------------------------------------------")
    println()
end
