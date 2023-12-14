abstract type Results end
abstract type CondensedResults <: Results end
abstract type StoredResults{T} <: Results end
abstract type Aggregation <: CondensedResults end
abstract type SimpleStats <: Aggregation end

mutable struct Const{T} <: CondensedResults
    n::Int
    value::T
end

mutable struct Sum{T} <: Aggregation
    n::Int
    sum::T
end

mutable struct BinomialStats{T} <: SimpleStats
    n::Int
    sum::T
end

mutable struct NormalStats{T} <: SimpleStats
    n::Int
    sum::T
    sumSq::T
    min::T
    max::T
end

mutable struct StoredValues{T} <: StoredResults{T}
    values::Vector{T}
    loc::Int                # location of next slot to store a value
end

# used when an object (i.e, a struct) is stored instead of a single value
#   - StoredValues can be extracted from StoredObjects using [] (i.e., getindex()) 
#     to perform statistics on, such as mean, var, etc.
#   - you can extract a field or a computation from various fields
mutable struct StoredObjects{T} <: StoredResults{T}
    values::Vector{T}
    loc::Int                # location of next slot to store an object
end

# synonym for StoredObjects
const StoredRecords = StoredObjects
const StoredStates  = StoredObjects

# Wrapper for the creation of a new Results value of type "storeAs"
#    - Used in concert with the results[:field] accessor using a functor
#      e.g., results(NormalStats)[:field]
#    - Implemented through the Decorator Pattern
struct StoredAs{T,SR} <: StoredResults{T}
    results::SR
    storeAs::UnionAll
end
