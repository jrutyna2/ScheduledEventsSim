import Dates.Time

events_path      = source_path * "Events/"
event_path       = events_path * "Event/"
eventSystem_path = events_path * "Event System/"
eventList_path   = events_path * "EventList/"
qSystem_path     = events_path * "QueueingSystem/"

include(event_path * "[Event] definition.jl")
include(eventList_path * "[Clock] definition.jl")
include(eventList_path * "[EventList] definition.jl")

include(event_path * "[Event] interface.jl")
include(eventList_path * "[EventList] interface.jl")
include(eventSystem_path * "[EventSim] runsim.jl")
include(eventSystem_path * "[EventSim] verbose.jl") 
include(qSystem_path * "[QueueingSystem] interfaces.jl") 

eventsLoaded = true
