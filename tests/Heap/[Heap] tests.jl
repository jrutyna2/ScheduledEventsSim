include("./deps/build.jl")

pq = BasicHeap(:hi, 5)
peek(pq)

pq = BasicHeap(:hi=>5, order = :lt)
peek(pq)

pq = BasicHeap{Symbol}(:hi=>5)
peek(pq)


pq = BasicHeap{Symbol,Int}(order = :lt)
peek(pq)
add!(pq, 5, :hi)
peek(pq)

pq = BasicHeap{Symbol,Int}()
peek(pq)
add!(pq, 5, :hi)
peek(pq)

add!(pq, 7, :there)

pq
show_qID(pq)

pq[:hello] = 6
pq[:aa] = 9
pq[:bb] = 3
pq[:cc] = 4
pq[:bb] = 7
pq[:bb] = 3

pqValue = extract!(pq)
pq
show_qID(pq)

pqValue = dequeue!(pq)
pq
show_qID(pq)

pq[:bb] = 3
pq[:bb] = 3

for pair in pq
    println(pair)
end

function foo()
    heap = BasicHeap(:hi=>5)
    heap[:there] = 7
    print(heap);print("\n")
end

#-----------------
ia = IndexAssociation(:hi, 5)
ia[:hi]
ia[:hi] = 7

ia = IndexAssociation{Symbol}()
ia[:hi] = 5
ia[:hi]
ia[:hi] = 7




#-----------------
pq = SearchableHeap(:hi, 5)
peek(pq)

pq = SearchableHeap(:hi, 5, <)
peek(pq)

pq = SearchableHeap(:hi=>5, <)
peek(pq)

pq = SearchableHeap{Symbol,Int}(<)
peek(pq)
add!(pq, 5, :hi)
peek(pq)

pq = SearchableHeap{Symbol, Symbol, Int}()
peek(pq)
add!(pq, 5, :hi)
peek(pq)

pq = SearchableHeap{Symbol, Int}()
peek(pq)
add!(pq, 5, :hi)
peek(pq)


add!(pq, 7, :there)

pq
show_qID(pq)
associations(pq)

pq[:hello] = 6
pq[:aa] = 9
pq[:bb] = 3
pq[:cc] = 4

pqValue = extract!(pq)

pq
show_qID(pq)
associations(pq)

change!(pq, 2, :hello)
change!(pq, 4, :cc)
change!(pq, 6, :hello)
change!(pq, 2, :hello)

pq
show_qID(pq)
associations(pq)

pq[:aa] = 2
pq[:dd] = 4
pq[:toDelete] = 3

delete!(pq, :toDelete)
