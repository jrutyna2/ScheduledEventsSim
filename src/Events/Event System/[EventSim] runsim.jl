#----------------------------------------------------------------------------------------------------
#  Setting up runsim by generating the eventlist and startstate

function runsim(sim::DiscreteEventSim, v::Verbosity)
    runsim( sim, eventlist(sim), v)
end

function runsim(sim::DiscreteEventSim, eventList::EventList, v::Verbosity)
    runsim( sim, startstate(sim), eventList, v)
end


#----------------------------------------------------------------------------------------------------
#  runsim for sims with ** Fixed ** event lists

function runsim(sim::DiscreteEventSim, state, eventList::FixedEL, v)
    ☼verbose☼(v, ☼Header☼, sim)
    ☼verbose☼(v, ☼InitState☼, sim, eventList, state)
    i = 0
    if !isfound(sim, state)
        for event in eventList
            stats!(event, sim, state)
            state!(event, sim, state)
            i = i + 1
            ☼verbose☼(v, ☼Update☼, sim, eventList, event, state, i)
            isfound(sim, state) && break
        end
    end
    measure(sim, measure(sim), state)
end

#----------------------------------------------------------------------------------------------------
#  runsim for sims with ** Appendable ** event lists

function runsim(sim::DiscreteEventSim, eventsList::QueueEL, v)
    runsim(sim, maxitr(sim), eventsList, v)
end

function runsim(sim::DiscreteEventSim, maxItr::Nothing, eventsList::QueueEL, v)
    error("A maxitr() function must be defined for event simulators that have appendable event lists. Otherwise they may never terminate")
end

function runsim(sim::DiscreteEventSim, maxItr, eventsList::QueueEL, v)
    runsim(sim, maxItr, startstate(sim), eventsList, v)
end

function runsim(sim::DiscreteEventSim, maxItr, state, eventList::Union{QueueEL,StackEL}, v)
    i = 0
    ☼verbose☼(v, ☼Header☼, sim)
    ☼verbose☼(v, ☼InitState☼, sim, eventList, state)
    while i <= maxItr && !isfound(sim, state)
        event = nextevent!(eventList)
        stats!(event, sim, state, eventList)
        state!(event, sim, state, eventList)
        ☼verbose☼(v, ☼Update☼, sim, eventList, event, state, i)
        i = i + 1
    end
    stats!(cleanup, sim, state, eventList)
    measure(sim, measure(sim), state)
end


#----------------------------------------------------------------------------------------------------
#  runsim for sims with ** Schedulable ** event lists

function runsim(sim::DiscreteEventSim, state, eventList::SchedEL, v)
    ☼verbose☼(v, ☼Header☼, sim)
    ☼verbose☼(v, ☼InitState☼, sim, eventList, state, currenttime(eventList))
    event = Before()
    while !(isend(event) || isempty(eventList) || isfound(sim, state))
        event = nextevent!(eventList)
        stats!(event, sim, state, eventList)
        state!(event, sim, state, eventList)
        ☼verbose☼(v, ☼Update☼, sim, eventList, event, state, currenttime(eventList))
    end
    ☼verbose☼(v, ☼Footer☼, sim)
    measure(sim, measure(sim), state)
end
