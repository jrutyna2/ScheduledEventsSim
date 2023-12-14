#---------------------------------
# Verbose printing of the Event and State / Stats

function verbose(h::☼Header☼, s::TRCSystem)
    print("-------------------------------------------------------------------------")
    println()
    @printf("|%30s %9s %3s %33s %16s %32s %16s %32s %16s", "|", "General", "|", "Service Center 1", "|", "Service Center 2", "|", "Service Center 3", "|")
    println()
    print("-------------------------------------------------------------------------")
    println()
    @printf("%s%s %-7s %7s", "[curr]", "[post]", "event", "Δtime")
    @printf("%7s %6s", "IAT", "N")
    @printf("%8s %6s", "LQ₁", "LS₁")
    @printf("%8s %6s %6s", "NW₁", "WQ₁", "WS₁")
    @printf("%8s %7s", "T₁∀idle", "T₁∀busy")
    @printf("%5s %6s", "LQ₂", "LS₂")
    @printf("%8s %6s %6s", "NW₂", "WQ₂", "WS₂")
    @printf("%8s %7s", "T₂∀idle", "T₂∀busy")
    @printf("%5s %6s", "LQ₃", "LS₃")
    @printf("%8s %6s %6s", "NW₃", "WQ₃", "WS₃")
    @printf("%8s %7s", "T₃∀idle", "T₃∀busy")
    println()
    print("-------------------------------------------------------------------------")
    println()
end

verbose(::☼Time☼,  sim::TRCSystem, currTime)     =  @printf("[%4d]", currTime)
☼preevent(sim::TRCSystem, name)        =  @printf("[%4d] %-8s %6d", 0, name, 0)
☼event(sim::TRCSystem, name, e::Event) =  @printf("[%4d] %-8s %6d", timestamp(e), name, Δpost(e))

verbose(::☼PreEvent☼, sim::TRCSystem)           =  ☼preevent(sim, "before")
verbose(::☼Event☼, sim::TRCSystem, e::Arrival)  =  ☼event(sim, "arrival", e)
verbose(::☼Event☼, sim::TRCSystem, e::EndEvent) =  ☼event(sim, "end", e)
verbose(::☼Event☼, sim::TRCSystem, e::D1)       =  ☼event(sim, "service₁", e)
verbose(::☼Event☼, sim::TRCSystem, e::D2)       =  ☼event(sim, "service₂", e)
verbose(::☼Event☼, sim::TRCSystem, e::D3)       =  ☼event(sim, "service₃", e)

function ☼servicecenterstate(sim::TRCSystem, state, i)
    noServers  =  noservers(sim, i)
    allServers =  allservers(sim, i)
    @printf("%7d %6d", state.queue[i], state.serving[i])
    @printf("%8d %6d %6d", state.NW[i], state.WQ[i], state.WS[i])
    @printf("%6d %7d", state.TS[i][noServers + 1], state.TS[i][allServers + 1])
end

function ☼generalstate(sim::TRCSystem, state)
    @printf("%7d %6d", state.IAT, state.N)
end

function verbose(::☼State☼, sim::TRCSystem, state)
    ☼generalstate(sim, state)
    ☼servicecenterstate(sim, state, 1)
    ☼servicecenterstate(sim, state, 2)
    ☼servicecenterstate(sim, state, 3)
end

function verbose(::☼Footer☼, sim::TRCSystem)
    print("-------------------------------------------------------------------------")
    println()
end
