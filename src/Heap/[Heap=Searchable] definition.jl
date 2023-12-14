#---------------------------------------------------------------------
# Type Definition

mutable struct SearchableHeap{D,K,P} <: DataHeap
    order::Symbol
    lastIndex::Int
    count::Int
    data::Vector{D}
    priorityValues::Vector{P}
    queueID::Vector{Int}
    indexAssoc::IndexAssociation{K}
end


#---------------------------------------------------------------------
# Constructors

function SearchableHeap{D,P}(;order = :lt) where {D <: Any, P <: Any}
    SearchableHeap{D,D,P}(order)
end

function SearchableHeap{D,K,P}(;order = :lt) where {D <: Any, K <: Any, P <: Any}
    SearchableHeap{D,K,P}(order)
end

function SearchableHeap{D,K,P}(order::Symbol) where {D <: Any, K <: Any, P <: Any}
    checkordersymbol(order)
    priorityValues = Vector{P}(undef, 1024)
    data = Vector{D}(undef, 1024)
    qID = Vector{Int}(undef, 1024)
    indexAssoc = IndexAssociation{K}()
    SearchableHeap(order, 0, 0, data, priorityValues, qID, indexAssoc)
end

#----------------------

function SearchableHeap(pair; order = :lt)
    SearchableHeap(pair[1], pair[2]; order)
end

function SearchableHeap{D}(pair; order = :lt) where D <: Any
    SearchableHeap{D}(pair[1], pair[2]; order)
end

function SearchableHeap(datum, priority; order = :lt)
    SearchableHeap{typeof(datum),typeof(priority)}(datum, priority, order)
end

function SearchableHeap{D}(datum, priority; order = :lt) where D <: Any
    SearchableHeap{D,typeof(priority)}(datum, priority, order)
end

function SearchableHeap{D,P}(datum, priority; order = :lt) where {D <: Any, P <: Any}
    SearchableHeap{D,P}(datum, priority, order)
end

function SearchableHeap{D,P}(datum, priority, order)  where {D <: Any, P <: Any}
    checkordersymbol(order)
    priorityValues = Vector{P}(undef, 1024)
    data = Vector{D}(undef, 1024)
    qID = Vector{Int}(undef, 1024)

    priorityValues[1] = priority
    data[1] = datum
    qID[1] = 1

    SearchableHeap(order, 1, 1, data, priorityValues, qID, IndexAssociation(datum))
end


#---------------------------------------------------------------------
# Accessors

associations(heap::SearchableHeap)   = heap.indexAssoc
