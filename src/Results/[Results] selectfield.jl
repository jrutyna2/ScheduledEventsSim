#-----------------------------------------------------
# selectfield(results::StoredObjects, fieldName) i.e. results[:fieldName]
#   - Select one field from StateResult to perform stats (returned as a Results subtype ... default as StoredValues)
#   - acts analogously to a slice (without @view abilities ... but views are not really feasible given the data structure used)

function getvalue(array, indices, dim = 1)
    ( dim > length(indices) )  ?  array  :  getvalue(array[indices[dim]], indices, dim + 1)
end

firstvalue(results::StoredObjects, fieldName::Symbol) = getfield(results[1], fieldName)

function firstvalue(results::StoredObjects, fieldName::Symbol, indices...)
    getvalue(getfield(results[1], fieldName), (indices...,))
end

function addvalues!(selectedResults, results::StoredValues)
    for i = 2:length(results)
        add!(selectedResults, results[i])
    end
end

function addvalues!(selectedResults, results::StoredObjects, fieldName::Symbol)
    for i = 2:length(results)
        add!(selectedResults, getfield(results[i], fieldName))
    end
end

function addvalues!(selectedResults, results::StoredObjects, fieldName::Symbol, indices...)
    indices = (indices...,)
    for i = 2:length(results)
        array = getfield(results[i], fieldName)
        add!(selectedResults, getvalue(array, indices))
    end
end

function selectfield(results::StoredValues, RT::Type)
    selectedResults = RT(results[1], length(results))
    addvalues!(selectedResults, results)
    selectedResults
end

function selectfield(results::StoredObjects, fieldName::Symbol)
    selectedResults = StoredValues(firstvalue(results, fieldName), length(results))
    addvalues!(selectedResults, results, fieldName)
    selectedResults
end

function selectfield(results::StoredObjects, fieldName::Symbol, indices...)
    selectedResults = StoredValues(firstvalue(results, fieldName, indices...), length(results))
    addvalues!(selectedResults, results, fieldName, indices...)
    selectedResults
end

#---------- StoredAs Objects: Converting to different storage structures

(results::StoredValues)(saveAs::UnionAll)  =  selectfield(results, saveAs)

function (results::StoredObjects)(saveAs::UnionAll)
    StoredAs{eltype(results),typeof(results)}(results, saveAs)
end

function selectfield(sa::StoredAs)
    results = storedresults(sa)
    ResultsType = store_as(sa)
    if ResultsType <: Const 
        Const(length(results), results[1])
    else
        selectResults = ResultsType(results[1])
        addvalues!(selectResults, results)
        selectResults
    end
end

function selectfield(sa::StoredAs, fieldName::Symbol)
    results = storedresults(sa)
    ResultsType = store_as(sa)
    if ResultsType <: Const 
        Const(length(results), getfield(results[1], fieldName))
    else
        selectResults = ResultsType(firstvalue(results, fieldName))
        addvalues!(selectResults, results, fieldName)
        selectResults
    end
end

function selectfield(sa::StoredAs, fieldName::Symbol, indices...)
    results = storedresults(sa)
    ResultsType = store_as(sa)
    if ResultsType <: Const 
        Const(length(results), getfield(results[1], fieldName)[indices...])
    else
        selectResults = ResultsType(firstvalue(results, fieldName, indices...))
        addvalues!(selectResults, results, fieldName, indices...)
        selectResults
    end
end
