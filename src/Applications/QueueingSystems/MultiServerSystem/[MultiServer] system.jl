#---------------------------------
# Sim

struct MultiServerSystem{Time} <: QueueingSystem 
    servers::Int
    endTime::Time
end

const MSSystem = MultiServerSystem

MultiServerSystem(;end_time = 0.0, servers = 1) = MSSystem(servers, end_time)

servers(sim::MSSystem) = sim.servers


#---------------------------------
# Events

@makeevent Arrival
@makeevent Departure

arrival(sim::MSSystem)   = Arrival
departure(sim::MSSystem) = Departure

initialevent(sim::MSSystem) = arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct MultiServerState{Time} <: State
    queue::Int
    serving::Int
    N::Int
    NW::Int
    WQ::Time
    WS::Time
    TS::Vector{Time}
    Tmax::Time
    IAT::Time
end

const MSState = MultiServerState

function startstate(sim::MSSystem)
    z  = zero(TimeType(sim))
    zv = zeros(TimeType(sim),servers(sim) + 1)              # add 1 to include case where no server is busy
    MSState(0, 0, 0, 0, z, z, zv, z, z)
end

# some useful informational methods
serving(s::MSState)                 =  s.serving
allbusy(sim::MSSystem, s::MSState)  =  servers(sim) == serving(s)
allidle(s::MSState)                 =  serving(s) == 0
queue(s::MSState)                   =  s.queue
queueempty(s::MSState)              =  queue(s) == 0

# some useful update methods
incqueue!(s::MSState)   =  (s.queue += 1)
decqueue!(s::MSState)   =  (s.queue -= 1)
incserving!(s::MSState) =  (s.serving += 1)
decserving!(s::MSState) =  (s.serving -= 1)


#---------------------------------
# Arrival event state and stats updates

function state!(event::Arrival, sim::MSSystem, state, eventList)
    if allbusy(sim, state)
        incqueue!(state)
    else
        incserving!(state)
        post!(eventList, Departure, servicetime(sim))
    end
    post!(eventList, Arrival, interarrivaltime(sim))
end

function stats!(event::Arrival, sim::MSSystem, state, eventList)
    state.IAT += Δpost(event)                                # the iat is the difference btw the current and posting times
    state.N = state.N + 1
    allbusy(sim, state) && (state.NW += 1)                   # when all servers are busy, customer is added to the queue 
    state.WQ += Δprev(eventList) * queue(state)
    state.WS += Δprev(eventList) * serving(state)
    @offset state.TS[serving(state)] += Δprev(eventList)     # remember Julia is 1 indexed, not zero index, so @offset used
    state.Tmax += Δprev(eventList)
end


#---------------------------------
# Departure event state and stats updates

function state!(event::Departure, sim::MSSystem, state, eventList)
    if queueempty(state)
        decserving!(state)
    else
        decqueue!(state)
        post!(eventList, Departure, servicetime(sim))
    end
end

function stats!(event::Departure, sim::MSSystem, state, eventList)
    state.WQ += Δprev(eventList) * queue(state)
    state.WS += Δprev(eventList) * serving(state)
    @offset state.TS[serving(state)] += Δprev(eventList)               # remember Julia is 1 indexed, not zero index, so @offset used
    state.Tmax += Δprev(eventList)
end



#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::MSSystem, state, eventList)
    state.WQ += Δprev(eventList) * queue(state)
    state.WS += Δprev(eventList) * serving(state)
    @offset state.TS[serving(state)] += Δprev(eventList)               # remember Julia is 1 indexed, not zero index, so @offset used
    state.Tmax += Δprev(eventList)
end
