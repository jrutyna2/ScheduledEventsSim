# Event Simulations (Fixed Number of Events)
To create an Event simulation with a fixed number of events, define the following:

First, subtype your Sim with respect to the `DiscreteEventSim` type

    struct MyEventSim <: DiscreteEventSim
        parm1::P1Type
        etc.
    end
`
Then create event singletons: one per event type

    struct E1 <: Event end
    struct E2 <: Event end
    struct E3 <: Event end
    struct E4 <: Event end
    struct E5 <: Event end
    etc.  ...

Next, create a event list - this will, of course, be simulation dependent:

    eventlist(sim::MyEventSim) = EventList(E3, E2, E1, E2, E3, E4, E5, E4, E3)

Next, create a `state!()` update function, one per event   
- (these replace the single `update!()` function from `StateSim`)

    function state!(sim::MyEventSim, e::E1, state)
        state update function for event E1
    end 

    function state!(sim::MyEventSim, e::E2, state)
        state update function for event E2
    end

    etc.

Finally, setup the rest of simulator as you would a regular state simulator by defining
- `MyState <: State`
- `startstate()`
- `show()` for verbose mode

You do **not** have to: 
- define a `maxitr` 
    - as the list itself implies the number of iterations (the length of the list)
- define `update!()`
    - this is already covered by the `state!()` method for each event

