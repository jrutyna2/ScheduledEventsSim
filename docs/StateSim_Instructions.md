
# State Simulations
## Creating a State Simulation with a fixed number of iterations
Define the following:

Simulation, including constants. It must include the field    `maxitr::Int`

    struct SimName <: StateSim
        maxitr::Int
        parm1::Type1
        parm2::Type2
        etc.  
    end 

Optionally, you can create an outer constructor for the simulation type. 
It is good form to have maxitr as a keyword (you can set the default to whatever you want ... not just 1)

    [optional] function SimName(arg1, arg2, ...; maxitr = 1)
        body of outer constructor
        must return call from an inner constructor  
        SimName(maxitr, parm1Val, parm2Val, ...)
    end

Next, you have to have a State structure to be used in the State Simulator.  

The structure must be mutable; i.e., fields are not just read only but can have values assigned to them.  

Again, you can define an optional outer constructor

    mutable struct SimStateName <: State
        var1::Type1
        var2::Type2
        etc.
    end

    [optional] function SimStateName(arg1, arg2, ...)`  
        body of outer constructor
        must return call from an inner constructor  
        SimStateName(parm1Val, parm2Val, ...)
    end

Instead of the Monte Carlo Simulator's `nextvalue()` function, you need to write two functions - `startstate(sim)` and `update!(sim, state)`

The purpose of `startstate(sim)` is to create a state, initialized to the starting values, to be passed into `update!(sim, state)`

    function startstate(sim::SimName)
        body of startstate
        sim.parm1 etc. can be used in the startstate() body  
        must return a `State` object of type 'SimStateName' 
            initialized to the start state of the simulation  
        SimStateName(var1_value, var2_value, ...)
    end

    function update!(sim::SimName, state)
        body of simulation state update
        updates the `State` (not the `Sim`)
        sim.parm1` etc. in sim body
        can use and assign to `state.var1` etc. update! body
        
    end

Note: as the return value is unused, you can return any value you want (or return no value in particular)

## Creating a State Simulation with a end goal
Instead of only running for `maxitr` number of times and just stopping, the simulation can end when a goal is reached.

This is done by defining a Boolean function `isfound()` that takes a state and constants  from the simulator struct and determines if the goal has been reached or not.

    [optional] function isfound(sim::SimName, state)
        returns true if the goal is found, else returns false
    end

`maxitr` must still be defined so the simulation can terminate even when the goal wasn't reached.  

## Verbose Mode
You can run a simulator in "verbose" mode, which will print out state information after each `update!()`. 

To do this, you need to extend the function `show()` with a method for your simulator's current state

    function show(s::StateName)
        println("var1 = s.var1")
        println("var2 = s.var2")
        etc. ...
    end

There are two other functions that control the printing of the states:

    verbose_withlinenum(sim::SimName) = false

This function will automatically print the "update" number before printing the state.  

It's default is true, so if you are representing the current update some other way, set it to `false` as in the example above.  

The second verbose control function is

    verbose_splitstate(sim::MonteHall) = true

This will place a blank line between state updates.  

It's default is `false`, which is useful if there is only one line printing out all state information. However, if you use multiple lines to print out the state, you would want to set it to `true` as in the example above.

## Using the State Simulator with a fixed number of iterations
load your definitions, then create the simulator and run it  

    sim = SimName(parm1_value, parm2_value, ...)
    runsim(sim; verbose = true)

This will run the simulator once, printing out the state each time it updates.  

If you are running the simulation multiple times, you run it using `repeat()` just as you did with Monte Carlo simulations.  

However, unlike Monte Carlo simulations, the default behaviour is to return the full final State object (unless you have set up a `measure(sim::SimName)`, which will be discussed later).  

You need to extract a value to be analyzed using 'mean' 'var' etc. To do this, use the `[]` with the name of the variable you want to extract, written as a symbol. You should store the extracted values in a new variable, and then apply your analysis functions

    sim = SimName(parm1_value, parm2_value, ...)
    results = repeat(sim, 1000)
    
    v1 = results[:var1]
    mean(v1)
    std(v1)

    v2 = results[:var2]
    mean(v2)
    std(v2)


