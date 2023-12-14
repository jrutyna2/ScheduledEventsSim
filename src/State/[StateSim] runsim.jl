#--------------------------------------------
#  Simulation's runsim() interface when called directly, not through repeat()

runsim(sim::Simulation; verbose = false) =  runsim(sim, verbosity(verbose))

#--------------------------------------------
#  runsim() as called using repeat()

runsim(sim::StateSim, v::Verbosity) = runsim( sim, startstate(sim), v)

function runsim(sim::StateSim, state, v)
    ☼verbose☼(v, ☼Header☼, sim)
    ☼verbose☼(v, ☼InitState☼, sim, state)
    for i = 1:maxitr(sim)
        isfound(sim, state) && break
        update!(sim, state)
        ☼verbose☼(v, ☼Update☼, sim, state, i)
    end
    measure(sim, measure(sim), state)
end
