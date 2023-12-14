function deletingindex!(heap::DataHeap, i)
    heap.lastIndex != i  &&  move!(heap, heap.lastIndex, i)
    heap.lastIndex -= 1
    i < heap.lastIndex  &&  bubbledown!(heap, i)
    i > 1 && bubbleup!(heap, i)
end

deleteindex!(heap::DataHeap, i) = deletingindex!(heap, i)

function deleteindex!(heap::SearchableHeap, i)
    datum = getdata(heap, i)
    deletingindex!(heap, i)
    delete!(associations(heap), datum)
    nothing
end

function updateindex!(heap::DataHeap, newData, i)
    data(heap)[i] = newData
end

function changeindex!(heap::DataHeap, newPriority, i)
    priorityvalues(heap)[i] = newPriority
    bubbledown!(heap, i)
    bubbleup!(heap, i)
    newPriority
end

getindex(heap::DataHeap, i) = ( data(heap)[i], priorityvalues(heap)[i] )

function getindex(heap::DataHeap, pd::Symbol, i)
    (pd === :priority ? priorityvalues(heap)[i] :
    (pd === :data     ? data(heap)[i]       : error("First dim should be either :priority or :data - $pd used instead")))
end
