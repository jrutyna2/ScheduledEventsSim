app_path         = source_path * "Applications/"
mc_path          = app_path * "MonteCarloSystems/"
state_path       = app_path * "StateSystems/"
fixedevents_path = app_path * "FixedEventsSystems/"
queueingsys_path = app_path * "QueueingSystems/"

# Computing PI
PI_path = mc_path * "Computing_PI/"
include(PI_path * "[PI][Sim] setup.jl")

# Drunkards Walk
DW_path = state_path * "Drunkards_Walk/"
include(DW_path * "[DW] type_definitions.jl")
include(DW_path * "[DW] interface.jl")

# Drunkards Walless Walk
DWW_path = state_path * "Drunkards_Walless_Walk/"
include(DWW_path * "[DWW] type_definitions.jl")
include(DWW_path * "[DWW] interface.jl")

# Monte Hall Problem
MH_path = fixedevents_path * "Monte_Hall_Problem/"
include(MH_path * "[MH][Sim] definition.jl")
include(MH_path * "[MH][State] definition.jl")
include(MH_path * "[MH][Event] definition.jl")
include(MH_path * "[MH] choosing_doors.jl")
include(MH_path * "[MH] interface.jl")

SingleServer_path = queueingsys_path * "SingleServerSystem/"
include(SingleServer_path * "[SingleServer] system.jl")
include(SingleServer_path * "[SingleServer] verbose.jl")

MultiServer_path = queueingsys_path * "MultiServerSystem/"
include(MultiServer_path * "[MultiServer] system.jl")
include(MultiServer_path * "[MultiServer] verbose.jl")

TwoCenters_path = queueingsys_path * "TwoCentersSystem/"
include(TwoCenters_path * "[TwoCentersSystem] system.jl")
include(TwoCenters_path * "[TwoCentersSystem] verbose.jl")

ThreeCenters_path = queueingsys_path * "ThreeCentersSystem/"
include(ThreeCenters_path * "[ThreeCentersSystem] system.jl")
include(ThreeCenters_path * "[ThreeCentersSystem] verbose.jl")  # If you have a verbose file

simAppsLoaded = true
