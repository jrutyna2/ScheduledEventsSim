#---------------------------------
# Sim

struct TwoCentersSystem{Time} <: QueueingSystem 
    servers::Vector{Int}
    endTime::Time
end

const TCSystem = TwoCentersSystem

TCSystem(;end_time = 0.0, c1 = 1, c2 = 1) = TCSystem([c1, c2], end_time)

servers(sim::TCSystem)       =  sim.servers
servers(sim::TCSystem, i)    =  servers(sim)[i]
allservers(sim::TCSystem, i) =  servers(sim, i)
noservers(sim::TCSystem, i)  =  0


#---------------------------------
# Events

@makeevent Arrival
@makeevent D1
@makeevent D2

arrival(sim::TCSystem)      =  Arrival
departure(sim::TCSystem)    =  (D1, D2)
departure(sim::TCSystem, i) =  departure(sim)[i]

initialevent(sim::TCSystem) =  arrival(sim)


#---------------------------------
# State and Stats
#    - all state and stats variables exist in the system's State
#    - updates to this general state is separated into state!() and stats! update functions
#      to more easily understand and design the simulation
#    - however, in actuality, both functions update the general system state 
#      (i.e., there isn't a separate stats struct)

mutable struct TwoCentersState{Time} <: State
    queue::Vector{Int}
    serving::Vector{Int}
    N::Int
    NW::Vector{Int}
    WQ::Vector{Time}
    WS::Vector{Time}
    TS::Vector{Vector{Time}}
    Tmax::Time
    IAT::Time
end

const TCState = TwoCentersState

function startstate(sim::TCSystem)
    z  = zero(TimeType(sim))
    zv1 = zeros(TimeType(sim),servers(sim, 1) + 1)              # add 1 to include case where no server is busy
    zv2 = zeros(TimeType(sim),servers(sim, 2) + 1)              # add 1 to include case where no server is busy
    TCState([0,0], [0,0], 0, [0,0], [z,z], [z,z], [zv1,zv2], z, z)
end

# some useful informational methods
serving(s::TCState)                    =  s.serving
serving(s::TCState, i)                 =  serving(s)[i]
allbusy(sim::TCSystem, s::TCState, i)  =  servers(sim, i) == serving(s, i)
allidle(sim::TCSystem, s::TCState, i)  =  serving(s, i) == 0
queue(s::TCState)                      =  s.queue
queue(s::TCState, i)                   =  queue(s)[i]
queueempty(s::TCState, i)              =  queue(s, i) == 0

# some useful update methods
incqueue!(s::TCState, i)   =  (s.queue[i] += 1)
decqueue!(s::TCState, i)   =  (s.queue[i] -= 1)
incserving!(s::TCState, i) =  (s.serving[i] += 1)
decserving!(s::TCState, i) =  (s.serving[i] -= 1)


#---------------------------------
# Common state! and stats! update subroutines

function state!_arriving(sim::TCSystem, state, eventList, i)
    if allbusy(sim, state, i)
        incqueue!(state, i)
    else
        incserving!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim, i))
    end
end

function state!_leaving(sim::TCSystem, state, eventList, i)
    # customer leaves service center i
    if queueempty(state, i)
        decserving!(state, i)
    else
        decqueue!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim, i))
    end
end

function stats!_timeupdate(sim::TCSystem, state, event, eventList)
    state.IAT += Δpost(event)                                # the iat is the difference btw the current and posting times
    for i = 1:2
        state.WQ[i]   +=   Δprev(eventList) * queue(state, i) 
        state.WS[i]   +=   Δprev(eventList) * serving(state, i)
        @offset (1,0) state.TS[i][serving(state, i)]  +=  Δprev(eventList)            # remember Julia is 1 indexed, not zero index, so need @offset
    end
    state.Tmax    +=   Δprev(eventList)
end

inc_NW!(sim::TCSystem, state, i)  =  allbusy(sim, state, i) && (state.NW[i] += 1)


#---------------------------------
# Arrival event updates

function state!(event::Arrival, sim::TCSystem, state, eventList)
    # arrived - schedule a new arrival
    post!(eventList, arrival(sim), interarrivaltime(sim))

    # customer goes to first service center
    state!_arriving(sim::TCSystem, state, eventList, 1)
end

function stats!(event::Arrival, sim::TCSystem, state, eventList)
    state.N = state.N + 1
    inc_NW!(sim::TCSystem, state, 1)                   # when all servers are busy, customre is added to Q1 
    stats!_timeupdate(sim::TCSystem, state, event, eventList)
end


#---------------------------------
# D1 event updates

function state!(event::D1, sim::TCSystem, state, eventList)
    # customer leaves service center 1
    state!_leaving(sim, state, eventList, 1)

    # customer arrives at center 2
    state!_arriving(sim::TCSystem, state, eventList, 2)
end

function stats!(event::D1, sim::TCSystem, state, eventList)
    inc_NW!(sim::TCSystem, state, 2)                   # when all servers are busy, customre is added to Q2 
    stats!_timeupdate(sim, state, event, eventList)
end


#---------------------------------
# D2 event updates

function state!(event::D2, sim::TCSystem, state, eventList)
    # customer leaves service center 2
    state!_leaving(sim, state, eventList, 2)

    # customer exit system
end

function stats!(event::D2, sim::TCSystem, state, eventList)
    stats!_timeupdate(sim, state, event, eventList)
end


#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::TCSystem, state, eventList)
    stats!_timeupdate(sim::TCSystem, state, event, eventList)
end
