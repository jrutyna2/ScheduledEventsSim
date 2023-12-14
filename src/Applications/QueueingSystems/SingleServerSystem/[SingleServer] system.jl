#---------------------------------
# Sim

struct SingleServerSystem <: QueueingSystem end
const SSSystem = SingleServerSystem


#---------------------------------
# Events

@makeevent Arrival
@makeevent Departure

arrival(sim::SSSystem)   = Arrival
departure(sim::SSSystem) = Departure

initialevent(sim::SSSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct SingleServerState{Time} <: State
    #state
    queue::Int
    busy::Bool
    #stats
    N::Int
    NW::Int
    WQ::Time
    WS::Time
    T_idle::Time
    Tmax::Time
    IAT::Time
end

const SSState = SingleServerState

function startstate(sim::SSSystem)
    z = zero(TimeType(sim))
    SSState(0, false, 0, 0, z, z, z, z, z)
end

# some useful informational methods
serverbusy(s::SSState) = s.busy
serveridle(s::SSState) = !serverbusy(s)
queue(s::SSState)      = s.queue
queueempty(s::SSState) = queue(s) == 0

# some useful update methods
incqueue!(s::SSState)   = (s.queue += 1)
decqueue!(s::SSState)   = (s.queue -= 1)
serverbusy!(s::SSState) = (s.busy = true)
serveridle!(s::SSState) = (s.busy = false)


#---------------------------------
# Arrival event state and stats updates

function state!(event::Arrival, sim::SSSystem, state, eventList)
    if serverbusy(state)
        incqueue!(state)
    else
        serverbusy!(state)
        post!(eventList, departure(sim), servicetime(sim))
    end
    post!(eventList, arrival(sim), interarrivaltime(sim))
end

function stats!(event::Arrival, sim::SSSystem, state, eventList)
    state.IAT += Δpost(event)                       # the iat is the difference btw the current and posting times
    state.N = state.N + 1
    state.WQ += Δprev(eventList) * queue(state)
    state.Tmax += Δprev(eventList)
    if serverbusy(state)                            # since new customer is placed in the queue 
        state.NW += 1                               #      add 1 to number of customers who have had to wait in a queue
        state.WS += Δprev(eventList)
    else
        state.T_idle += Δprev(eventList)
    end
end


#---------------------------------
# Departure event state and stats updates

function state!(event::Departure, sim::SSSystem, state, eventList)
    if queueempty(state)
        serveridle!(state)
    else
        decqueue!(state)
        post!(eventList, departure(sim), servicetime(sim))
    end
end

function stats!(event::Departure, sim::SSSystem, state, eventList)
    state.WQ   +=  Δprev(eventList) * queue(state)
    state.WS   +=  Δprev(eventList)
    state.Tmax +=  Δprev(eventList)
end


#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::SSSystem, state, eventList)
    state.WQ += Δprev(eventList) * queue(state)
    state.Tmax +=  Δprev(eventList)
    if serverbusy(state)
        state.WS += Δprev(eventList)
    else
        state.T_idle += Δprev(eventList)
    end
end
