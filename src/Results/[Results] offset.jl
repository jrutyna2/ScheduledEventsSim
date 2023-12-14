#-----------------------------------------------------
# offset macro
#   - allows for zero offsets, or arbitrary value offsets of the index for either gettinbg or setting array values
#   - code generalized to handle the results[:field, index] facility of the simulator's interface
#   - setter is only designed to work with nested vectors (vectors of vectors of vectors ...), not rectilinear dense arrays
#   - getter can work with either
#   - macro is designed to work with the array[] interface only, not the getindex() functions that is eventually produced

macro offset(expr)
    if expr.head === :ref
        offset_getting!(0, expr)
    else
        offset_setting!(0, expr.args[1])
    end
    esc(expr)
end

macro offset(offsets, expr)
    if expr.head === :ref
        offset_getting!(eval(offsets), expr)
    else
        offset_setting!(eval(offsets), expr.args[1])
    end
    esc(expr)
end


#-----------------------------------------------------
# offset_getting!()
#   - Helper function for @offset macro
#   - Used in consert with results[:field, index]
#   - allows for zero offsets, or arbitrary value offsets of the index
#   - @offset (0, 1, 0) results[:field, 1, 1, 1] will access the values at [2, 1, 2]

function offset_getting!(offset::Int, expr)
    expr.args[end] = expr.args[end] + 1 - offset
end

function offset_getting!(offset::Tuple, expr)
    n = length(offset)
    for i = 0:(n-1)
        expr.args[end - i] = expr.args[end - i] + 1 - offset[n - i]
    end
end


#-----------------------------------------------------
# offset_setting!()
#   - Helper function for @offset macro
#   - Used to offset the array indices in nested arrays when setting the arrays
#   - allows for zero offsets, or arbitrary value offsets of the index
#   - @offset (0, 1, 0) results[:field, 1, 1, 1] will access the values at [2, 1, 2]

function offset_setting!(offset::Int, expr)
    expr.args[2] = :($(expr.args[2]) + 1 - $offset)
end

function offset_setting!(offset::Tuple, expr, dim = length(offset))
    offset_setting!(offset[dim], expr)
    dim > 1 && offset_setting!(offset, expr.args[1], dim - 1)
end
