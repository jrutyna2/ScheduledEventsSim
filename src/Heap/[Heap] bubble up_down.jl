#--------------------------------------------------------------
# bubbledown!

bubbledown!(heap::DataHeap,  i = 1) = bubblingdown!(heap, i)

function bubbledown!(heap::SearchableHeap,  i = 1)
    index = bubblingdown!(heap, i)
    associations(heap)[heap] = index
    index
end

function bubblingdown!(heap::DataHeap, i)
    higher = higherindex(heap, i)
    while higher != i
        swap!(heap, i, higher)
        i = higher
        higher = higherindex(heap, i)
    end
    i
end


#--------------------------------------------------------------
# bubbleup!

function bubbleup!(heap::DataHeap, i = lastindex(heap))
    bubblingup!(heap, i)
end

function bubbleup!(heap::SearchableHeap,  i = lastindex(heap))
    index = bubblingup!(heap, i)
    associations(heap)[heap] = index
    index
end

function bubblingup!(heap::DataHeap, i)
    while isparentlower(heap, i)
        swap!(heap, i, parentindex(i))
        i = parentindex(i)
    end
    i
end
