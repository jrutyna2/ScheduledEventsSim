show(io::IO, mime::MIME"text/plain", pq::DataHeap) = show(pq)
print(pq::DataHeap) = show(pq)

function printheapelement(data, priority)
    print(data)
    print(" => ") 
    print(priority)
end

function show(pq::DataHeap)
    print("(")
    for i=1:lastindex(pq)-1
        printheapelement(data(pq)[i], priorityvalues(pq)[i])
        print(", ")
    end
    printheapelement(data(pq)[lastindex(pq)], priorityvalues(pq)[lastindex(pq)])
    print(")")
end

function show_qID(pq::DataHeap)
    print(@view queueID(pq)[1:lastindex(pq)])
end
