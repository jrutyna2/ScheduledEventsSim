import Base.repeat
import DataStructures.update!
using Printf

state_path          = source_path * "State/"

include(state_path * "[State] definition.jl")
include(state_path * "[StateSim] interface.jl")
include(state_path * "[StateSim] runsim.jl")
include(state_path * "[StateSim] repeat.jl")
include(state_path * "[StateSim] verbose.jl") 

stateLoaded = true
