#---------------------------------
# Event interface 

TimeType(event::TimedEvent{T}) where T = T
ContentType(event::TimedEventWithContent{T,C}) where {T,C} = C

content(event::Event)  =  event.content
Δpost(event::Event)    =  event.Δpost
timestamp(event::Event) =  event.timeStamp

isbefore(e::Event)  = false
isbefore(e::Before) = true

isend(e::Event)    = false
isend(e::EndEvent) = true

#---------------------------------
# the End event should not have a state! update 

state!(update::EndEvent, sim, state, eventlist) = nothing


#---------------------------------
# assume stats! updates do not exist
#     - let the application overide the default

stats!(event, sim, state)                       = nothing
stats!(event, sim, state, eventlist)            = nothing


#---------------------------------
# printing events for Verbose

print(event::Event) = show(event)

function show(event::Event)
    @printf("\t%-11s", typeof(event))
end

