parentindex(i) = div(i,2)
leftchild(i) = 2i
rightchild(i) = 2i + 1

intree(heap::DataHeap, i)  =  i <= lastindex(heap)
belowroot(i)               =  i > 1
