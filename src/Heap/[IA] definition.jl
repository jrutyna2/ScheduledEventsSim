struct IndexAssociation{K}
    dict::Dict{K,Int}
end

IndexAssociation{K}() where K <: Any = IndexAssociation( Dict{K,Int}())
IndexAssociation(datum, index = 1)   = IndexAssociation( Dict( key(datum)=> index))
