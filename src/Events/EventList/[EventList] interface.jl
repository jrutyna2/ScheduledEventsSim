#------------------------------------------------
# Private accessors

events(el::EventList)       = el.events
clock(el::EventList)        = el.clock
endtime(el::SchedEL)        = el.endTime
hasterminalend(el::SchedEL) = el.hasTerminalEnd
priorityqueue(el::SchedEL)  = el.events
queue(el::QueueEL)          = el.events
stack(el::QueueEL)          = el.events


#------------------------------------------------
# Private methods

peek(el::StackEL)  =  isempty(el) ? nothing : last(stack(el))
peek(el::QueueEL)  =  isempty(el) ? nothing : first(queue(el))
peek(el::SchedEL)  =  isempty(el) ? nothing : peek(priorityqueue(el))

dequeue!(el::QueueEL)       = isempty(el) ? nothing : dequeue!( events(el))
dequeue_pair!(el::SchedEL) = isempty(el) ? nothing : dequeue_pair!( events(el))

futuretime(el::SchedEL, Δtime) = futuretime(clock(el), Δtime)
time!(el::SchedEL, newTime)    = time!(clock(el), newTime)

# add! is a generaized synonym for append!, push! and post!
add!(el::QueueEL, event)                     = append!(el, event)
add!(el::StackEL, event)                     = push!(el, event)
add!(el::SchedEL, event, Δtime, contents...) = post!(el, event, Δtime, contents...)

append!(el::QueueEL, E::Type)      = append!(el, E())                 # converting event types to events
append!(el::QueueEL, event::Event) = enqueue!(queue(el), event)

push!(el::StackEL, E::Type)      = push!(el, E())                 # converting event types to events
push!(el::StackEL, event::Event) = push!(stack(el), event)


#------------------------------------------------
# Public Inteface: Informational
#     - length(), isempty(), upcoming(), Δprev(), currenttime(), prevtime()

iterate(el::FixedEL)                    = iterate( events(el))
iterate(el::FixedEL, state)             = iterate( events(el), state)

function iterate(el::EventList, state = nothing)
    event = nextevent!(el)
    event === nothing ? nothing : (event, nothing)
end

length(el::EventList)  = length(events(el))
isempty(el::EventList) = (length(el) == 0)

upcoming(el::StackEL)     = peek(el)
upcoming(el::QueueEL)     = peek(el)
upcoming(el::SchedEL)     = peek(el)[1]
upcomingtime(el::SchedEL) = peek(el)[2]

Δprev(el::SchedEL)             = Δprev(clock(el))
currenttime(el::SchedEL)       = time(clock(el))
prevtime(el::SchedEL)          = prevtime(clock(el))


#------------------------------------------------
# Public Inteface: Mutators
#     - nextevent!(), post!()

nextevent!(el::FixedEL)       =  popfirst!(events(el))        # slow - better to iterate
nextevent!(el::QueueEL)  =  dequeue!(queue(el))
nextevent!(el::StackEL) =  pop!(stack(el))

function nextevent!(el::SchedEL)
    pair = dequeue_pair!(events(el))
    if pair === nothing
        nothing
    else
        (event, clockTime) = pair
        time!(el, clockTime)
        event
    end
end
 
function post!(eventsList::SchedEL, PostingEvent::Type, Δtime, contents...)
    currTime = currenttime(eventsList)
    post!(eventsList::SchedEL, PostingEvent(currTime, Δtime, contents...))
end

function post!(eventsList::SchedEL, event::Event)
    futTime  = futuretime(eventsList, Δpost(event))
    add!(priorityqueue(eventsList), futTime, event)
end


#----------------------
# Public Display - especially for verbose

show(io::IO, mime::MIME"text/plain", el::SchedEL) = show(el)
print(el::SchedEL) = show(el)

function show(el::SchedEL)
    if hasterminalend(el)
        print("[$(currenttime(el)) << $(endtime(el))] ")
    else
        print("[$(currenttime(el)) < $(endtime(el))] ")
    end
    print(events(el))
end


#----------------------
# Public Searchable

getindex(el::Searchable_SchedEL, event)        = getindex( events(el), event)
setindex!(el::Searchable_SchedEL, time, event) = setindex!( events(el), time, event)
delete!(el::Searchable_SchedEL, datum)         = delete!(events(el), datum)

