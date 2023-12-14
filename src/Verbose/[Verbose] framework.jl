abstract type Verbosity end
struct Silent <: Verbosity end
struct Verbose <: Verbosity end

abstract type ☼Cmd☼ end
struct ☼Header☼  <: ☼Cmd☼ end
struct ☼Footer☼  <: ☼Cmd☼ end
struct ☼Value☼   <: ☼Cmd☼ end
struct ☼Line☼    <: ☼Cmd☼ end
struct ☼Divider☼ <: ☼Cmd☼ end 

verbose(h::☼Header☼, sys)  =  nothing
verbose(f::☼Footer☼, sys)  =  nothing
verbose(l::☼Line☼, sys, i) =  nothing
verbose(l::☼Divider☼, sys) =  println()

verbosity(verbose::Bool) = verbose ? Verbose() : Silent()

@generated function ☼verbose☼(verbosity, ☼Cmd, args...)
    if verbosity <: Silent
        return :(nothing)
    else
        return :(verbose(☼Cmd(), args...))
    end
end

# @generated function verbose!(verbosity, args...)
#     if verbosity <: Silent
#         return :(nothing)
#     else
#         return :(verbose(args...))
#     end
# end

# const verbosefn = verbose!

