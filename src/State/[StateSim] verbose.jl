struct ☼InitState☼    <: ☼Cmd☼ end
struct ☼State☼        <: ☼Cmd☼ end
struct ☼Update☼       <: ☼Cmd☼ end 

verbose(s::☼State☼, sim::StateSim, state)     =  print(state)
verbose(s::☼InitState☼, sim::StateSim, state) =  verbose(☼Update☼(), sim, state)

function verbose(::☼Update☼, sim::StateSim, state, i = 0)
    verbose(☼Line☼(), sim, i)
    verbose(☼State☼(), sim, state)
    verbose(☼Divider☼(), sim)
end

function verbose(sim::Simulation, state, i) 
    verbose_withlinenum(sim) && verbose_linenum(sim, i)
    verbose_state(sim, state)
end
