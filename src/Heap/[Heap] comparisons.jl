#--------------------------------------------------------
# ishigher

function ishigher(heap::DataHeap, priority, qID, higher, lower)
    if priority[lower] != priority[higher]
        if isreverse(heap)
            priority[higher] > priority[lower]
        else
            priority[higher] < priority[lower]
        end
    else
        qID[higher] < qID[lower]
    end
end


#--------------------------------------------------------
# isparentlower

isparenthigher(heap::DataHeap, child) = !isparentlower(heap, child)

function isparentlower(heap::DataHeap, child)
    if belowroot(child)
        parent = parentindex(child)
        isparentlower(heap, priorityvalues(heap), queueID(heap), parent, child)
    else
        false
    end
end

function isparentlower(heap::DataHeap, priority, qID, parent, child)
    ishigher(heap, priority, qID, child, parent)
end


#--------------------------------------------------------
# ischildhigher

ischildlower(heap::DataHeap, child, other) = !ischildhigher(heap, child, other)

function ischildhigher(heap::DataHeap, child, other)
    if intree(heap, child)
        ishigher(heap, priorityvalues(heap), queueID(heap), child, other)
    else
        false
    end
end


#--------------------------------------------------------
# higherindex

function higherindex(heap::DataHeap, i)
    left = leftchild(i)
    right = rightchild(i)
    ischildhigher( heap, left, i)  &&  ( i = left )
    ischildhigher( heap, right, i)  ?  right : i
end
