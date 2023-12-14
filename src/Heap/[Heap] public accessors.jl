struct Data end
struct Priority end

const heap_data = Data()
const hd = Data()
const heap_priority = Priority()
const hp = Priority()

findindex(heap::SearchableHeap, data) = findindex(associations(heap), data)

getindex(heap::DataHeap) = peek(heap)

getdata(heap::DataHeap, i = 1) = data(heap)[i]
getpriority(heap::DataHeap, i = 1) = priorityvalues(heap)[i]

function getindex(heap::SearchableHeap, datum)
    ind = findindex(heap, datum)
    ind === missing ? missing : priorityvalues(heap)[ind]
end

function setindex!(heap::DataHeap, priority, datum)
    add!(heap, priority, datum)
end

setindex!(heap::SearchableHeap, priority, datum)               = change!(heap, priority, datum)
setindex!(heap::SearchableHeap, priority, hp::Priority, datum) = ( heap[datum] = priority )
