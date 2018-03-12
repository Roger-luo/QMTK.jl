export SpaceState, Randomized, Initialized

"""
state of a sample space: `Randomized`, `Initialized`, etc.
"""
abstract type SpaceState end

"""
This sample space is randomized. (current sample is a initialized randomly)
"""
abstract type Randomized <: SpaceState end

"""
This sample space is initialized. (current sample is a certain default one)
"""
abstract type Initialized <: SpaceState end

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

# Abstracts for space
export AbstractSpace, israndomized

"""
    AbstractSpace{T, S}

General abstract type for space with `T` as its content
in state `S`.

In fact, an instance of a space should be a type with a
temporary memory to store an element of the space in type `T`.
"""
abstract type AbstractSpace{T, S<:SpaceState} end
israndomized(x::AbstractSpace{T, Randomized}) where {T} = true
israndomized(x::AbstractSpace{T, S}) where {T, S} = false

# Interface Definitions
export data, reset!, copy, acquire, shake!, randomize!

# Properties
"""
    data(space::AbstractSpace{T, S}) -> T

get the current data of this space
"""
function data(space::AbstractSpace) end

# Basics
"""
    reset!(space) -> space # with initilized state

reset the temporary data of this space to initial position
be careful that the state of the space will also be changed
assign it to your variable manually.

```julia
space = reset!(space)
```
"""
function reset!(space::AbstractSpace) end

"""
    copy(space) -> space

copy the space instance
"""
function copy(space::AbstractSpace) end

"""
    acquire(space) -> element

get a copy of current element of the space
"""
function acquire end

# Random methods
"""
    shake!(space) -> space

shake the space and move current element to a random position.
the space has to be a space with `Randomized` state. or it will
an `UnRandomizedError`.
"""
function shake! end

"""
    randomize!(space) -> space

randomized the space, move current element to a random position
and change the state of this space to `Initialized`
"""
function randomize! end

export AbstractSpaceTraverser, traverse

abstract type AbstractSpaceTraverser end

"""
    traverse(space) -> iterator

get an iterator that traverses the whole space.
"""
function traverse end

################################
# Some default definitions
################################

reset!(space::AbstractSpace{T, Initialized}) where T = space
randomize!(space::AbstractSpace{T, Randomized}) where T = space

function shake!(space::AbstractSpace{T, Initialized}) where T
    throw(UnRandomizedError())
end

include("Real.jl")
include("Sites.jl")
