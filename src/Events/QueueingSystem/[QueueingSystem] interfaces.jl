abstract type QueueingSystem <: DiscreteEventSim end

endtime(sim::QueueingSystem)     =  error("endtime(sim::Q) where Q <: QueueingSystem must be defined")
starttime(sim::QueueingSystem)   =  zero(TimeType(sim))
searchable(sim::QueueingSystem)  =  false
terminalend(sim::QueueingSystem) =  true
TimeType(sim::QueueingSystem)    =  Float64

function timeconsistencycheck(startTime, endTime)
    if endTime <= startTime
        error("The end time must be greater than the clock's start time.\n" *
              "eventTime = $eventTime, startTime =  $startTime")
    end
end

function eventlist(sim::QueueingSystem)
    timeconsistencycheck(starttime(sim), endtime(sim))
    eventList = SchedEL(initialevent(sim);
                        TimeType = TimeType(sim), 
                        startTime = starttime(sim), 
                        searchable = searchable(sim), 
                        terminalEnd = terminalend(sim))
    post!(eventList, EndEvent, endtime(sim) - starttime(sim))
    eventList
end

