#---------------------------------------------------------------------
# Type Definition

abstract type DataHeap end

mutable struct BasicHeap{D,P} <: DataHeap
    order::Symbol
    lastIndex::Int
    count::Int
    data::Vector{D}
    priorityValues::Vector{P}
    queueID::Vector{Int}
end

#---------------------------------------------------------------------
# Constructors

function checkordersymbol(order::Symbol)
    !in(order, (:lt,:gt)) && error(":order = $order; it must be either :lt or :gt")
end

function BasicHeap{D,P}(;order = :lt) where {D <: Any, P <: Any}
    checkordersymbol(order)
    priorityValues = Vector{P}(undef, 1024)
    data = Vector{D}(undef, 1024)
    qID = Vector{Int}(undef, 1024)
    BasicHeap(order, 0, 0, data, priorityValues, qID)
end

#------

function BasicHeap(pair; order = :lt)
    BasicHeap(pair[1], pair[2]; order)
end

function BasicHeap{D}(pair; order = :lt) where D <: Any
    BasicHeap{D}(pair[1], pair[2]; order)
end

function BasicHeap(datum, priority; order = :lt)
    BasicHeap{typeof(datum),typeof(priority)}(datum, priority, order)
end

function BasicHeap{D}(datum, priority; order = :lt) where D <: Any
    BasicHeap{D,typeof(priority)}(datum, priority, order)
end

function BasicHeap{D,P}(datum, priority; order = :lt) where {D <: Any, P <: Any}
    BasicHeap{D,P}(datum, priority, order)
end

function BasicHeap{D,P}(datum, priority, order) where {D <: Any, P <: Any}
    checkordersymbol(order)
    priorityValues = Vector{P}(undef, 1024)
    data = Vector{D}(undef, 1024)
    qID = Vector{Int}(undef, 1024)

    priorityValues[1] = priority
    data[1] = datum
    qID[1] = 1

    BasicHeap(order, 1, 1, data, priorityValues, qID)
end

#---------------------------------------------------------------------
# Accessors

priorityvalues(heap::DataHeap) = heap.priorityValues
data(heap::DataHeap)           = heap.data
predID(heap::DataHeap)         = heap.predID
lastindex(heap::DataHeap)      = heap.lastIndex
uniqueID(heap::DataHeap)       = heap.count
queueID(heap::DataHeap)        = heap.queueID
space(heap::DataHeap)         = length(priorityvalues(heap))

isreverse(order::Symbol)  = order === :lt ? false : true
isreverse(heap::DataHeap) = isreverse(heap.order)
