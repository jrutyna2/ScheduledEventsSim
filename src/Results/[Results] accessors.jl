###########################################
#  Accessors for StoredResults
import Base.eltype

storedresults(sa::StoredAs) = sa.results
store_as(sa::StoredAs) = sa.storeAs

values(r::StoredResults) =  r.values
values(r::StoredAs)      =  values(storedresults(r))

fillindex(r::StoredResults) = r.loc
fillindex(r::StoredAs) = fillindex(storedresults(r))

eltype(r::StoredResults{T}) where T = T


###########################################
# results[] i.e., getindex()

getindex(r::Results)  =   mean(r)

getindex(c::Const)    =   value(c)
getindex(c::Const, i) =   value(c)

getindex(r::StoredResults, index)         =   values(r)[index]
setindex!(r::StoredResults, value, index) = ( values(r)[index] = value )

getindex(results::StoredValues)                                            =  selectfield(results)
getindex(results::StoredObjects, fieldName::Symbol)                        =  selectfield(results, fieldName)
getindex(results::StoredObjects, fieldName::Symbol, indices...)            =  selectfield(results, fieldName, indices...)
# getindex(results::StoredObjects, RT::Type, fieldName::Symbol)              =  selectfield(RT, results, fieldName)
# getindex(results::StoredObjects, RT::Type, fieldName::Symbol, indices...)  =  selectfield(RT, results, fieldName, indices...)

getindex(results::StoredAs)                                           =  selectfield(results)
getindex(results::StoredAs, fieldName::Symbol)                        =  selectfield(results, fieldName)
getindex(results::StoredAs, fieldName::Symbol, indices...)            =  selectfield(results, fieldName, indices...)
