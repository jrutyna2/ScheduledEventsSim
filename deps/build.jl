# Add required packages for all subsystems
import Pkg
Pkg.add("Distributions")      # used to generate various distributions (e.g., Normal) in Applications
Pkg.add("StatsBase")          # used in Results
Pkg.add("HypothesisTests")    # used in Results
Pkg.add("DataStructures")     # used in Results

# Setup relative paths to the source code
source_path = pwd() * "/src/"
deps_path   = pwd() * "/deps/"

function loading(moduleName, fileName, path = deps_path)
    println("Loading " * moduleName)
    include(path * fileName)
end


!@isdefined(resultsLoaded)  &&  loading("Results", "results_build.jl")
!@isdefined(verboseLoaded)  &&  loading("Verbose", "verbose_build.jl")
!@isdefined(simLoaded)      &&  loading("Simulator", "simulator_build.jl")
!@isdefined(stateLoaded)    &&  loading("State", "state_build.jl")
!@isdefined(heapLoaded)     &&  loading("Heap", "heap_build.jl")
!@isdefined(eventsLoaded)   &&  loading("Events", "events_build.jl")
!@isdefined(simAppsLoaded)  &&  loading("Applications", "applications_build.jl")

println("Complete")
