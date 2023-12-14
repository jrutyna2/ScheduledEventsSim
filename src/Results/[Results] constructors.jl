#----------------------
# Results - selecting and setting up the correct subtype

Results(RT::Type, value, reps)               = ( RT <: StoredResults )  ?  RT(value, reps)  :  RT(value)

# for all constructors, x is the result of the first simulation run that doesn't have a missing value

Const(x) = Const(1, x)
Sum(x) = Sum(1, x)
BinomialStats(x) = BinomialStats(1, x)
NormalStats(x) = NormalStats(1, x, x^2, x, x)
StoredValues(v::Vector{T}) where T = StoredValues{T}(v, length(v) + 1)    # fill pointer is length(vector) + 1
StoredValues(x, n::Int)  = StoredResults(StoredValues::Type, x, n)
StoredObjects(x, n::Int) = StoredResults(StoredObjects::Type, x, n)

function StoredResults(StoredResults::Type, x, n::Int)
    ElType = typeof(x)
    values = Vector{ElType}(undef, n)
    values[1] = x
    StoredResults{ElType}(values, 2)
end
