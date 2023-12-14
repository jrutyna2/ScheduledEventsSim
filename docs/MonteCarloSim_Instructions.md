# Monte Carlo Simulations (Simple)
## Creating a Simple Monte Carlo Simulation 
Define the following

`struct SimName <: MonteCarloSim end`  

`function nextvalue(sim::SimName)`  
&ensp;&ensp;&ensp;&ensp;`body of simulation`  
&ensp;&ensp;&ensp;&ensp;returns the next simulated value  
`end`

## Using a Simple Monte Carlo Simulation 
Load your definition, then create the simulator and run it  
`sim = SimName()`  
`results = repeat(sim, 1000)`

You can then run statistics on the results  
`mean(results)`  
`var(results)`  
`std(results)`  
`confint(results)`  
`minimum(results)`  
`maximum(results)`  

# Monte Carlo Simulations that has Parameters
## Creating a  Monte Carlo Simulation that has Parameters 
Define the following

    struct SimName <: MonteCarloSim   
        parm1::Type1  
        parm2::Type2  
        etc.  
    end  


    [optional] function SimName(arg1, arg2, ...)  
        body of outer constructor  
        must return call from an inner constructor  
        SimName(parm1Val, parm2Val, ...)  
    end

    [optional] function SimName(arg1, arg2, ...)  
        body of outer constructor  
        must return call from an inner constructor  
        SimName(parm1Val, parm2Val, ...)  
    end


    function nextvalue(sim::SimName) 
        body of simulation
        can use `sim.parm1` etc. in sim body 
        returns the next simulated value  
    end

## Using a Monte Carlo Simulation that has Parameters 
Load your definition, then create the simulator and run it  

`sim = SimName(parm1_value, parm2_value, ...)`  
`results = repeat(sim, 1000)`  


