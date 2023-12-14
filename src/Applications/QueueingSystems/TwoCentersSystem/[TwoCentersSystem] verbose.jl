#---------------------------------
# Verbose printing of the Event and State / Stats
#    ☼ = \sun

function verbose(h::☼Header☼, s::TCSystem)
    print("-------------------------------------------------------------------------")
    print("-------------------------------------------------------------------------")
    println()
    @printf("|%30s %9s %3s %33s %16s %32s %16s", "|", "General", "|", "Service Center 1", "|", "Service Center 2", "|")
    println()
    print("-------------------------------------------------------------------------")
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
    println()
    print("-------------------------------------------------------------------------")
    print("-------------------------------------------------------------------------")
    println()
end

verbose(::☼Time☼,  sim::TCSystem, currTime)     =  @printf("[%4d]", currTime)

☼preevent(sim::TCSystem, name)        =  @printf("[%4d] %-8s %6d", 0, name, 0)
☼event(sim::TCSystem, name, e::Event) =  @printf("[%4d] %-8s %6d", timestamp(e), name, Δpost(e))

verbose(::☼PreEvent☼, sim::TCSystem)           =  ☼preevent(sim, "before")
verbose(::☼Event☼, sim::TCSystem, e::Arrival)  =  ☼event(sim, "arrival", e)
verbose(::☼Event☼, sim::TCSystem, e::EndEvent) =  ☼event(sim, "end", e)
verbose(::☼Event☼, sim::TCSystem, e::D1)       =  ☼event(sim, "service₁", e)
verbose(::☼Event☼, sim::TCSystem, e::D2)       =  ☼event(sim, "service₂", e)

# note: @offset(1,0) is not used - so TS[1][1] as used here would be @offset(1,0) TS[1][0], etc., where TS[centerᵢ][LSᵢ]
function ☼servicecenterstate(sim::TCSystem, state, i)
    noServers  =  noservers(sim, i)
    allServers =  allservers(sim, i)
    @printf("%7d %6d", state.queue[i], state.serving[i])
    @printf("%8d %6d %6d", state.NW[i], state.WQ[i], state.WS[i])
    @printf("%6d %7d", state.TS[i][noServers + 1], state.TS[i][allServers + 1])
end

function ☼generalstate(sim::TCSystem, state)
    @printf("%7d %6d", state.IAT, state.N)
end

function verbose(::☼State☼, sim::TCSystem, state)
    ☼generalstate(sim, state)
    ☼servicecenterstate(sim, state, 1)
    ☼servicecenterstate(sim, state, 2)
end

function verbose(::☼Footer☼, sim::TCSystem)
    print("-------------------------------------------------------------------------")
    print("-------------------------------------------------------------------------")
    println()
end
