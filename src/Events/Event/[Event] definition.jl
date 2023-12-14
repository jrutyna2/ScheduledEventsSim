#-------------------------------------------------------------------
# Event Definitions
abstract type Event end
abstract type TimedEvent{T} <: Event end
abstract type SimpleTimedEvent{T} <: TimedEvent{T} end
abstract type TimedEventWithContent{T,C} <: TimedEvent{T} end

#-------------------------------------------------------------------
# Constructor: @makeevent

eventname!(expr::Expr, eventName) = (expr.args[2].args[2].args[1].args[1] = eventName)

function eventnamecheck(eventName, eventType)
    E = getglobal(Main, eventName)
    !(typeof(E) <: Type) && error("$eventName is already defined - choose another name")
    !(E <: SimpleTimedEvent)  && error("Attempt to redefine $eventName as a $(String(eventType)) - Events cannot be redefined")
    true
end

function makeevent(eventName::Symbol; with_content = false)
    with_content ? makeevent_wcontent(eventName) : makeevent_simple(eventName)
end

function makeevent_simple(eventName::Symbol)
    if isdefined(Main, eventName) && eventnamecheck(eventName, :SimpleTimedEvent)
        return nothing
    end

    eventDefinition = quote 
        struct EventType{T} <: SimpleTimedEvent{T}
            timeStamp::T
            Δpost::T
        end
    end
    
    eventname!(eventDefinition, eventName)
    eval(eventDefinition)
end  

function makeevent_wcontent(eventName::Symbol)
    if isdefined(Main, eventName) && eventnamecheck(eventName, :TimedEventWithContent)
        return nothing
    end

    eventDefinition = quote 
        struct EventType{T,C} <: TimedEventWithContent{T,C}
            postTime::T
            Δpost::T
            content::C
        end
    end

    eventname!(eventDefinition, eventName)
    eval(eventDefinition)
end  

withcontent(s::String)  =  s[end] == '⁺'
eventsymbol(s::String)  =  Symbol(withcontent(s) ? s[1:end-1] : s)

macro makeevent(eventCode)
    eventStr = String(eventCode)
    makeevent(eventsymbol(eventStr); with_content = withcontent(eventStr))
end


#-------------------------------------------------------------------
# Standard Events for all systems

struct Before <: Event end
@makeevent EndEvent
