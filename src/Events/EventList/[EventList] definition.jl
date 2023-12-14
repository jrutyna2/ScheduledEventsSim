using DataStructures
import Base.stack

#------------------------------------------------
# Type Definition

abstract type EventList end

abstract type SchedEL  <: EventList end

struct FixedEL{N,Event} <: EventList
    events::NTuple{N,Event}
end

struct StackEL{Event} <: EventList
    events::Vector{Event}
end

struct QueueEL{Event} <: EventList
    events::Queue{Event}
end

struct Simple_SchedEL{Event,Time} <: SchedEL
    clock::Clock{Time}
    hasTerminalEnd::Bool
    events::BasicHeap{Event,Time}
end

struct Searchable_SchedEL{Event,Key,Time} <: SchedEL
    clock::Clock{Time}
    endTime::Time
    hasTerminalEnd::Bool
    events::SearchableHeap{Event,Key,Time}
end


#------------------------------------------------
# Constructors

function EventList(first::Type, rest...)
    N = length(rest) + 1
    FixedEL{N,Event}((first(),  map(Event->Event(), rest)...))
end

function EventList(first::Event, rest...)
    N = length(rest) + 1
    FixedEL{N,Event}((first, rest...))
end

function EventList(eventListType::Symbol, args...; keywords...)
    if eventListType === :queue
        QueueEL(args...)
    elseif eventListType === :stack
        StackEL(args...)
    elseif eventListType === :schedule
        SchedEL(args...; keywords...)
    else
        error("The first argument, must be an event type, or the symbol :append.\n" * 
              "The symbol $eventListType was used instead.")
    end
end

#-------------------------------------------------------
# Queue Event List constructors

QueueEL()                          = QueueEL(Queue{Event}())
QueueEL{E}() where E <: Event      = QueueEL(Queue{E}())
QueueEL(FirstEvent::Type, args...) = QueueEL(FirstEvent(args...))

function QueueEL(firstEvent::Event)
    E = typeof(firstEvent)
    el = QueueEL{E}()
    append!(el, firstEvent)
    el
end


#-------------------------------------------------------
# Stack Event List constructors

StackEL()                          = StackEL(Vector{Event}())
StackEL{E}() where E <: Event      = StackEL(Vector{E}())
StackEL(FirstEvent::Type, args...) = StackEL(FirstEvent(args...))

function StackEL(firstEvent::Event)
    E = typeof(firstEvent)
    el = StackEL{E}()
    push!(el, firstEvent)
    el
end


#-------------------------------------------------------
# Schedulable Event List constructors

function SchedEL(; initialEvent = nothing, TimeType = Float64, startTime = 0.0, searchable = false, terminalEnd = true)
    SchedEL(initialEvent;  TimeType, startTime, searchable, terminalEnd)
end

function SchedEL(initialEvent::Nothing; TimeType = Float64, startTime = 0.0, searchable = false, terminalEnd = true)
    error("A schedulable event list must have initialEvent set, e.g., EventList(:schedule, initialEvent = Arrival, endTime = 1000.0")
end

function SchedEL(InitialEvent::Type; TimeType = Float64, startTime = 0.0, searchable = false, terminalEnd = true)
    SchedEL(InitialEvent(startTime, zero(TimeType));  startTime, searchable, terminalEnd)
end

function SchedEL(initialEvent::Event; startTime = 0.0, searchable = false, terminalEnd = true)
    Heap    = searchable ? SearchableHeap     : BasicHeap
    SchedEL = searchable ? Searchable_SchedEL : Simple_SchedEL
    TT = TimeType(initialEvent)
    ET = supertype(typeof(initialEvent))

    heap = Heap{ET}(initialEvent, convert(TT, startTime))
    SchedEL(Clock{TT}(startTime), terminalEnd, heap)
end
