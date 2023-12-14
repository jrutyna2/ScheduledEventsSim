
#--------------------------------------------------
# Base heap manipulation functions
#    -   when applied, they break the heapify property
#    -   so bubbleup and/or bubbledown have to be called after these have been applied
# Do not use the heap[key] interface 
#    - the interface depends on swap! and move!
#    - so using it within these functions would cause an infinite regression

#--------------------------------------------------
# swap! functions

function swap!(vector::Vector, i, j)
    temp = vector[i]
    vector[i] = vector[j]
    vector[j] = temp
end

function swapping!(heap::DataHeap, from, to)
    swap!(priorityvalues(heap), from, to)
    swap!(data(heap), from, to)
    swap!(queueID(heap), from, to)
end

swap!(heap::DataHeap, from, to) = swapping!(heap, from, to)

function swap!(heap::SearchableHeap, from, to)
    swapping!(heap, from, to)
    associations(heap)[heap] = from
end


#--------------------------------------------------
# move! functions

function moving!(heap::DataHeap, from, to)
    priorityvalues(heap)[to]  =   priorityvalues(heap)[from]
    data(heap)[to]            =   data(heap)[from]
    queueID(heap)[to]         =   queueID(heap)[from]
end

move!(heap::DataHeap, from, to) = moving!(heap, from, to)

function move!(heap::SearchableHeap, from, to)
    moving!(heap, from, to)
    associations(heap)[heap]   =  to
end


#--------------------------------------------------
# append! helper functions

function inc!(heap::DataHeap)
    heap.lastIndex += 1
    heap.count += 1
end

function ensurespace(heap::DataHeap)
    if space(heap) < lastindex(heap) + 1
        newSpace = 2 * space(heap)
        resize!(priorityvalues(heap), newSpace)
        resize!(data(heap), newSpace)
        resize!(queueID(heap), newSpace)
    end
end

#--------------------------------------------------
# append! functions

function appending!(heap::DataHeap, newPriority, newData)
    ensurespace(heap)
    inc!(heap)
    lastIndex = lastindex(heap)
    priorityvalues(heap)[lastIndex] = newPriority
    data(heap)[lastIndex] = newData
    queueID(heap)[lastIndex] = uniqueID(heap)
end

append!(heap::DataHeap, newPriority, newData) = appending!(heap, newPriority, newData)

function append!(heap::SearchableHeap, newPriority, newData)
    appending!(heap, newPriority, newData)
    associations(heap)[newData] = lastindex(heap)
end
