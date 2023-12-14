# Setup relative paths to the source code if using Heap independent of simulation build
# source_path = pwd() * "/src/"
# import Pkg

import Base.getindex, Base.setindex!, Base.append!, Base.delete!, Base.iterate
import Base.print, Base.show, Base.isempty, Base.length
import DataStructures.inc!, DataStructures.first, DataStructures.enqueue!
import DataStructures.dequeue!, DataStructures.dequeue_pair!

Heap_path          = source_path * "Heap/"

# Load Results framework
include(Heap_path * "[IA] definition.jl")
include(Heap_path * "[Heap] definition.jl")
include(Heap_path * "[Heap=Searchable] definition.jl")
include(Heap_path * "[IA] accessors.jl")
include(Heap_path * "[Heap,index] navigation.jl")
include(Heap_path * "[Heap] comparisons.jl")
include(Heap_path * "[Heap,index] index functions.jl")
include(Heap_path * "[Heap] swap, move, append.jl")
include(Heap_path * "[Heap] bubble up_down.jl")
include(Heap_path * "[Heap] public functions.jl")
include(Heap_path * "[Heap] public accessors.jl")
include(Heap_path * "[Heap] print.jl")

heapLoaded = true
