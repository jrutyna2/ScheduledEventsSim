import Base.values, Base.count, Base.sum, Base.length
import Base.getindex, Base.setindex!
import Base.extrema, Base.maximum, Base.minimum
import Statistics.mean, Statistics.var, Statistics.std
import Statistics.median, Statistics.quantile
import Distributions.dof

results_path  =  source_path * "Results/"

include(results_path * "[Results] definition.jl")
include(results_path * "[Results] constructors.jl")
include(results_path * "[Results] accessors.jl")
include(results_path * "[Results] selectfield.jl")
include(results_path * "[Results] offset.jl")
include(results_path * "[Results] add!.jl")
include(results_path * "[Results] statistics.jl")
include(results_path * "[Results] ttest_ftest.jl")
include(results_path * "[Results] arithmetic.jl")

resultsLoaded = true
