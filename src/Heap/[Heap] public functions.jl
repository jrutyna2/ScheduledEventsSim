datum(pair) = pair[1]
priority(pair) = pair[2]

length(heap::DataHeap)  = lastindex(heap)
isempty(heap::DataHeap) = ( length(heap) == 0 )

function peek(heap::DataHeap, i = 1)
    isempty(heap) ? nothing : Pair( data(heap)[i], priorityvalues(heap)[i] )
end

first(heap::DataHeap) = peak(heap)

function extract!(heap::DataHeap)
    if isempty(heap)
        nothing
    else
        extracted = data(heap)[1]
        deleteindex!(heap, 1)
        extracted
    end
end

function extract_pair!(heap::DataHeap)
    if isempty(heap)
        nothing
    else
        extracted = peek(heap)
        deleteindex!(heap, 1)
        extracted
    end
end

dequeue!(heap::DataHeap) = extract!(heap)
dequeue_pair!(heap::DataHeap) = extract_pair!(heap)

function iterate(heap::DataHeap, state = nothing) 
    pair = dequeue_pair!(heap)
    (pair === nothing) ? nothing : (pair, nothing)
end

function add!(heap::DataHeap, newPriority, newData)
    append!(heap, newPriority, newData)
    bubbleup!(heap)
end

add!(heap::DataHeap, pair::Pair) = add!(heap, priority(pair), datum(pair))

enqueue!(heap::DataHeap, pair::Pair) = add!(heap, pair)
enqueue!(heap::DataHeap, newPriority, newData) = add!(heap, newPriority, newData)

function change!(heap::SearchableHeap, newPriority, datum)
    i = findindex(heap, datum)
    i === missing  ?  add!(heap, newPriority, datum)  :  changeindex!(heap, newPriority, i)
end

#####  needs to be tested
function update!(heap::SearchableHeap, newData, datum)
    i = findindex(heap, datum)
    if i === missing
        missing
    else
        updateindex!(heap, newData, i)

        if key(newData) == key(datum)
            delete!(associations(heap), datum)
            associations(heap)[newData] = i
        end

        newData
    end
end

function delete!(heap::SearchableHeap, datum)
    i = findindex(heap, datum)
    i === missing ? missing : deleteindex!(heap, i)
end
