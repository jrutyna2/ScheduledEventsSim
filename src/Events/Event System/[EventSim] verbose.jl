struct ☼Time☼      <: ☼Cmd☼ end
struct ☼PreEvent☼  <: ☼Cmd☼ end
struct ☼Event☼     <: ☼Cmd☼ end

verbose(cmd::☼Time☼,     sim::Simulation, currTime) =  nothing
verbose(cmd::☼PreEvent☼, sim::Simulation)           =  nothing
verbose(cmd::☼Event☼,    sim::Simulation, event)    =  print(event)

function verbose(cmd::☼InitState☼, sim::EventSim, eventList::EventList, state, i = 0)
    verbose(☼Line☼(),  sim, i)
    verbose(☼PreEvent☼(), sim)
    verbose(☼State☼(), sim, state)
    verbose(☼Divider☼(), sim)
end

function verbose(cmd::☼Update☼, sim::EventSim, eventList::EventList, event, state, i = 0)
    verbose(☼Line☼(),  sim, i)
    verbose(☼Event☼(), sim, event)
    verbose(☼State☼(), sim, state)
    verbose(☼Divider☼(), sim)
end

function verbose(cmd::☼InitState☼, sim::EventSim, eventList::SchedEL, state, currTime, i = 0)
    verbose(☼Line☼(),  sim, i)
    verbose(☼Time☼(),  sim, currTime)
    verbose(☼PreEvent☼(), sim)
    verbose(☼State☼(), sim, state)
    verbose(☼Divider☼(), sim)
end

function verbose(cmd::☼Update☼, sim::EventSim, eventList::SchedEL, event, state, currTime, i = 0)
    verbose(☼Line☼(),  sim, i)
    verbose(☼Time☼(),  sim, currTime)
    verbose(☼Event☼(), sim, event)
    verbose(☼State☼(), sim, state)
    verbose(☼Divider☼(), sim)
end
