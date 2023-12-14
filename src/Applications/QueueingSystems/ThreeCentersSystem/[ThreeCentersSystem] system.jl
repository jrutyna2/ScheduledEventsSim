# include("../../../../deps/build.jl")
#---------------------------------
# Sim

struct ThreeCentersSystem{Time} <: QueueingSystem 
    lambda_a::Float64           # Rate of exponential interarrival
    lambda_s::Vector{Float64}   # Rates for Erlang service times at each center
    k::Vector{Int}              # k parameters for Erlang service times at each center
    servers::Vector{Int}        # Number of servers in each center
    pchoice::Float64            # Probability of routing to second center
    endTime::Time
end

const TRCSystem = ThreeCentersSystem

# Initialize ThreeCentersSystem with parameters
TRCSystem(;lambda_a = 1.0, lambda_s = [1.0, 1.0, 1.0], k = [1, 1, 1], end_time = 0.0, c1 = 1, c2 = 1, c3 = 1, pchoice = 0.5) = TRCSystem(lambda_a, lambda_s, k, [c1, c2, c3], pchoice, end_time)

servers(sim::TRCSystem)       =  sim.servers
servers(sim::TRCSystem, i)    =  servers(sim)[i]
allservers(sim::TRCSystem, i) =  servers(sim, i)
noservers(sim::TRCSystem, i)  =  0
#---------------------------------
# Events
@makeevent Arrival
@makeevent D1
@makeevent D2
@makeevent D3  # Additional event for departures from the third center

arrival(sim::TRCSystem)      =  Arrival
departure(sim::TRCSystem)    =  (D1, D2, D3)  # Include D3 in the tuple
departure(sim::TRCSystem, i) =  departure(sim)[i]

initialevent(sim::TRCSystem) =  arrival(sim)

mutable struct ThreeCentersState{Time} <: State
    queue::Vector{Int}            # Queues at each center
    serving::Vector{Int}          # Number of customers being served at each center
    N::Int                        # Total number of arrivals
    NW::Vector{Int}               # Number of customers who had to wait at each center
    WQ::Vector{Time}              # Total waiting time in queue at each center
    WS::Vector{Time}              # Total service time at each center
    TS::Vector{Vector{Time}}      # Time spent with specific number of servers busy at each center
    Tmax::Time                    # Maximum simulation time
    IAT::Time                     # Inter-arrival time
    routing_decision::Int         # field to store the routing decision
end

const TRCState = ThreeCentersState
# Initialize the state for the ThreeCentersSystem
function startstate(sim::TRCSystem)
    z  = zero(TimeType(sim))
    zv1 = zeros(TimeType(sim), servers(sim, 1) + 1)  # Add 1 to include case where no server is busy
    zv2 = zeros(TimeType(sim), servers(sim, 2) + 1)  # Same for second center
    zv3 = zeros(TimeType(sim), servers(sim, 3) + 1)  # Same for third center
    initial_routing_decision = 2  # Initial routing decision
    TRCState([0, 0, 0], [0, 0, 0], 0, [0, 0, 0], [z, z, z], [z, z, z], [zv1, zv2, zv3], z, z, initial_routing_decision)
end

# Informational methods for the ThreeCentersState
serving(s::TRCState)                    =  s.serving
serving(s::TRCState, i)                 =  serving(s)[i]
allbusy(sim::TRCSystem, s::TRCState, i) =  servers(sim, i) == serving(s, i)
allidle(sim::TRCSystem, s::TRCState, i) =  serving(s, i) == 0
queue(s::TRCState)                      =  s.queue
queue(s::TRCState, i)                   =  queue(s)[i]
queueempty(s::TRCState, i)              =  queue(s, i) == 0

# Update methods for the ThreeCentersState
incqueue!(s::TRCState, i)   =  (s.queue[i] += 1)
decqueue!(s::TRCState, i)   =  (s.queue[i] -= 1)
incserving!(s::TRCState, i) =  (s.serving[i] += 1)
decserving!(s::TRCState, i) =  (s.serving[i] -= 1)

#---------------------------------
# Common state! and stats! update subroutines

function state!_arriving(sim::TRCSystem, state, eventList, i)
    if allbusy(sim, state, i)
        incqueue!(state, i)
    else
        incserving!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim, i))
    end
end

function state!_leaving(sim::TRCSystem, state, eventList, i)
    # Customer leaves service center i
    if queueempty(state, i)
        decserving!(state, i)
    else
        decqueue!(state, i)
        post!(eventList, departure(sim, i), servicetime(sim, i))
    end
end

function stats!_timeupdate(sim::TRCSystem, state, event, eventList)
    state.IAT += Δpost(event)  # The iat is the difference between the current and posting times
    for i = 1:3  # Updated to include the third center
        state.WQ[i] += Δprev(eventList) * queue(state, i)
        state.WS[i] += Δprev(eventList) * serving(state, i)
        @offset (1,0) state.TS[i][serving(state, i)] += Δprev(eventList)
    end
    state.Tmax += Δprev(eventList)
end

inc_NW!(sim::TRCSystem, state, i) = allbusy(sim, state, i) && (state.NW[i] += 1)

#---------------------------------
# Arrival event updates

function state!(event::Arrival, sim::TRCSystem, state, eventList)
    # Arrived - schedule a new arrival
    post!(eventList, arrival(sim), interarrivaltime(sim))

    # Customer goes to the first service center
    state!_arriving(sim, state, eventList, 1)
end

function stats!(event::Arrival, sim::TRCSystem, state, eventList)
    state.N = state.N + 1
    inc_NW!(sim, state, 1)  # When all servers are busy, customer is added to queue at center 1 
    stats!_timeupdate(sim, state, event, eventList)
end

#---------------------------------
# D1 event updates

function state!(event::D1, sim::TRCSystem, state, eventList)
    # Customer leaves service center 1
    state!_leaving(sim, state, eventList, 1)

    # Make a routing decision and store it in the state
    state.routing_decision = rand() < sim.pchoice ? 2 : 3

    # Customer is routed based on the decision
    state!_arriving(sim, state, eventList, state.routing_decision)
end

#Revised Stats Update for D1 Event
function stats!(event::D1, sim::TRCSystem, state, eventList)
    # The decision to route to center 2 or 3 should be stored 

    if state.routing_decision == 2
        inc_NW!(sim, state, 2)  # Customer is added to queue at center 2 if all servers are busy
    else
        inc_NW!(sim, state, 3)  # Customer is added to queue at center 3 if all servers are busy
    end

    stats!_timeupdate(sim, state, event, eventList)
end

#---------------------------------
# D2 event updates

function state!(event::D2, sim::TRCSystem, state, eventList)
    # Customer leaves service center 2
    state!_leaving(sim, state, eventList, 2)
end

function stats!(event::D2, sim::TRCSystem, state, eventList)
    stats!_timeupdate(sim, state, event, eventList)
end

#---------------------------------
# D3 event updates

function state!(event::D3, sim::TRCSystem, state, eventList)
    # Customer leaves service center 3
    state!_leaving(sim, state, eventList, 3)
end

function stats!(event::D3, sim::TRCSystem, state, eventList)
    stats!_timeupdate(sim, state, event, eventList)
end

#---------------------------------
# EndEvent stats update

function stats!(event::EndEvent, sim::TRCSystem, state, eventList)
    stats!_timeupdate(sim::TRCSystem, state, event, eventList)
end

