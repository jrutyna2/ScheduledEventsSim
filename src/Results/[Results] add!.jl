#   The interface function that integrates the Results with the Simulator
#   *  add(::Results, value)

#-------------------------------------------------------
# When adding a Missing value, do nothing

add!(s::Sum, value::Missing)           = nothing
add!(s::BinomialStats, value::Missing) = nothing
add!(s::NormalStats, value::Missing)   = nothing
add!(s::StoredValues, value::Missing)  = nothing

#-------------------------------------------------------
#  add!() of a single value

function add!(c::Const, value)
    c.n += 1
end

function add!(s::Sum, value)
    s.sum += value
    s.n += 1
end

function add!(s::BinomialStats, value)
    s.sum += value
    s.n += 1
end

function add!(stats::NormalStats, value)
    stats.sum += value
    stats.sumSq += value^2
    stats.min = min(stats.min, value)
    stats.max = max(stats.max, value)
    stats.n += 1
end

function add!(sv::StoredResults, value) 
    sv[fillindex(sv)] = value
    sv.loc += 1
end

