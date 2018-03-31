export SpaceState, UnRandomized, Randomized

abstract type SpaceState <: AbstractTag end
abstract type UnRandomized <: SpaceState end
abstract type Randomized <: SpaceState end

# Exceptions
export UnRandomizedError
import Base: show

"""
Some operations (like some samplers) only accepts randomized sample space

Throw this error, when the arugment does not meet this condition.
"""
struct UnRandomizedError <: Exception
end

function show(io::IO, e::UnRandomizedError)
    println(io, "Need to randomize first")
end
