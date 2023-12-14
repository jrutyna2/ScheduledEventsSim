key(data) = data

iadict(ia::IndexAssociation) = ia.dict

findindex(ia::IndexAssociation, datum) = get(iadict(ia), key(datum), missing)
getindex(ia::IndexAssociation, datum) = findindex(ia, datum)

setindex!(ia::IndexAssociation, index::Int, datum) = ( iadict(ia)[key(datum)] = index )

function setindex!(ia::IndexAssociation, index::Int, heap::DataHeap)
    datum = data(heap)[index]
    ia[datum] = index
end

delete!(ia::IndexAssociation, datum) = delete!(iadict(ia), key(datum))
