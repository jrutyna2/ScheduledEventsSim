# Measures
The results of a `runsim()` call when using `repeat()` returns the final state of that run. These states are stored in Results using a `StoredObjects` (also known as `StoredRecords`). 

This is the default behaviour. However it can be overridden by using the `measure()` facility in concert with the "results storage" facility such as `StoredValues` and `NormalStats`.

## Returning a Single Value from a Simulation   
The simplest way to return a single value from a simulation is to write a `measure()` function that returns a single value:

    function measure(sim::SimName, state)
        compute a returnValue using sim and state information
        returnValue
    end

You also have to tell the simulator that you are returning a single value and not a `StoredObjects`, which is the default. You do this by declaring the type of object the simulator returns(as a singleton):

    measure(sim::SimName) = ValueMeasure()

If these functions are included in your simulation's definition then the `repeat()` function will default to `StoredValues` instead of `StoredObject`. In other words, the following script will work without having to select the field from the returned state (as a value and not a state is return):

    sim = MySim()
    resultValues = repeat(sim, 1000)
    mean(resultValues)

Since values are returned, you can also used NormalStats or BinomialStats as you would with the Monte Carlo simulation.

    sim = MySim()
    resultValues = repeat(sim, 1000, NormalStats)
    mean(resultValues)

This would not work without the `measure()` methods setup to return a value as you can't add states together, only values.

## Returning a Multiple Value (different than the state) from a Simulation   
You can return a different struct than the simulation state using `measure()`.

Just define a structure:

    struct MyStruct
        measureVar1::VType1
        measureVar2::VType2
        etc. ...
    end

#### [optional] MyStruct Constructor  
    function MyStruct(arg1, arg2, ...)
        compute measureVar1, measureVar2 ..., using arg1, arg2, ...
        MyStruct(measureVar1, measureVar2 ...)
    end

You can then create a `measure()` function that returns a `MyStruct` object instead of a value.

`return()` will the use `StoredObjects` (a.k.a., `StoredRecords`) as its default instead of `StoredValues`

When you do this, you should treat the return object in the same way you do a returned state:

    sim = SimName(parm1_value, parm2_value, ...)
    results = repeat(sim, 1000)
    
    mv1 = results[:measureVar1]
    mean(mv1)
    std(mv1)

    mv2 = results[:measureVar2]
    mean(mv2)
    std(mv2)


## Switching between Measures
To most easily understand how to easily switch between different measures, a slightly simplified version of the Drunkard's Walk simulation will be used.

First define your simulator. Since you are choosing a measure, the measure that will be used will be stored in the StateSim struct. To ensure that the simulator remains fast, we have to tell the compiler which measure type was stored. This is done using a parameterized type  {M} in the struct name as follows (the names of both the parameterized type, `M`, and the field name, `dwmeasure`, are your choice)

    struct DWSim{M} <: StateSim
        maxitr::Int
        dwmeasure::M
        wallLoc::Int
        startPos::Int
        probLeft::Float64
    end

Next you have to tell the simulator the name of the field that your measure is stored in:

    measure(sim::DWSim) =  sim.dwmeasure

Next, create a set of singletons, one per measure that you want to choose among, and make sure they all have `Measure` as their supertype:

    struct StepsMeasure   <: Measure end
    struct AtLeftMeasure  <: Measure end
    struct AtRightMeasure <: Measure end

[Optional] You can create a constructor that takes a symbol and returns the sington instance:  
(remember to use the `()` after the singleton type name to create an instance of the type)

    function DWMeasure(m::Symbol)
        (m === :steps)     && return StepsMeasure()
        (m === :leftwall)  && return AtLeftMeasure()
        (m === :rightwall) && return AtRightMeasure()
        error("measure = $m; it must be one of (:steps, :leftwall, :rightwall)")
    end

Finally you need to declare a set of `measure()` methods, one per "measure option"

    measure(sim::DWSim, m::StepsMeasure, state)   =  steps(state)
    measure(sim::DWSim, m::AtLeftMeasure, state)  =  atleft(state)
    measure(sim::DWSim, m::AtRightMeasure, state) =  atright(state)

Notice that `measure()` takes three parameters instead of two. The middle parameter states which "measure option" you are defining.

Note: in the originally released software, instead of multiple dispatch to choose between options, a "metaprogramming" technique, akin to the use of macros, was used. Both work equally fast, however, the multiple dispatch code is easier to understand. That being said, the macro version can be easily modified as written, even if you don't understand the underlying mechanism of why it works.

## Running Simulations that Switch between Measures

To run the simulations that switch between measures, just pass in the measure you want as an argument to the Sim definition:

    maxItr, wallLoc, startLoc, probLeft  =  10000, 10, 0, 0.5

    dwsim = DWSim(maxItr, AtLeftMeasure, wallLoc, startLoc, probLeft)
    atLeftResults = repeat(dwsim, 1000)
    mean(atLeftResults)

    dwsim = DWSim(maxItr, Steps, wallLoc, startLoc, probLeft)
    stepsResults = repeat(dwsim, 1000)
    mean(stepsResults)

    dwsim = DWSim(maxItr, DWMeasure(:rightwall), wallLoc, startLoc, probLeft)
    stepsResults = repeat(dwsim, 1000)
    mean(stepsResults)
