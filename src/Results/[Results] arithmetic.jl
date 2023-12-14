
import Base.+, Base.*, Base./, Base.-, Base.^

rmap(fn::Function, args...)  = StoredValues( map(fn, map(values, args)...) )
r_map(fn::Function, args...) = map(fn, map(values, args)...)

function r_op(fn::Function, r1::StoredValues{T1}, r2::StoredValues{T2}) where {T1, T2}
    v3 = fn(values(r1), values(r2))
    StoredValues(v3, length(r1))
end

function r_op(fn::Function, r1::StoredValues{T1}, r2::T2) where {T1, T2}
    v3 = fn(values(r1), r2)
    StoredValues(v3, length(r1))
end

function r_op(fn::Function, r1::T1, r2::StoredValues{T2}) where {T1, T2}
    v3 = fn(r1, values(r2))
    StoredValues(v3, length(r1))
end

+(r1::StoredValues, r2::StoredValues) = r_op(.+, r1, r2)
+(r1::StoredValues, r2)               = r_op(.+, r1, r2)
+(r1, r2::StoredValues)               = r_op(.+, r1, r2)

-(r1::StoredValues, r2::StoredValues) = r_op(.-, r1, r2)
-(r1::StoredValues, r2)               = r_op(.-, r1, r2)
-(r1, r2::StoredValues)               = r_op(.-, r1, r2)

*(r1::StoredValues, r2::StoredValues) = r_op(.*, r1, r2)
*(r1::StoredValues, r2)               = r_op(.*, r1, r2)
*(r1, r2::StoredValues)               = r_op(.*, r1, r2)

/(r1::StoredValues, r2::StoredValues) = r_op(./, r1, r2)
/(r1::StoredValues, r2)               = r_op(./, r1, r2)
/(r1, r2::StoredValues)               = r_op(./, r1, r2)

^(r1::StoredValues, r2::StoredValues) = r_op(.^, r1, r2)
^(r1::StoredValues, r2)               = op(.^, r1, r2)
^(r1, r2::StoredValues)               = r_op(.^, r1, r2)
