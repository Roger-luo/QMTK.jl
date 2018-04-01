export kronsum
# TODO: see issue 27
function kronsum(f::Function, itr::LatticeIterator)
    state = start(itr)
    pos, state = next(itr, state)
    ex = f(getid(itr, pos)...)

    while !done(itr, state)
        pos, state = next(itr, state)
        ex = :($(f(getid(itr, pos)...)) + $ex)
    end

    return eval(toexpr(kronparse(ex)))
end

include("Core.jl")
include("RegionIter.jl")
