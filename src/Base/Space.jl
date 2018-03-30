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

# Space Interface
export data, reset!, copy, acquire, shake!, randomize!

"""
    data(space::AbstractSpace{T, S}) -> T

get the current data of this space
"""
function data(space::AbstractSpace) end

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
function acquire(space::AbstractSpace) end

"""
    shake!(space) -> space

shake the space and move current element to a random position.
the space has to be a space with `Randomized` state. or it will
an `UnRandomizedError`.
"""
function shake!(space::AbstractSpace) end

"""
    randomize!(space) -> space

randomized the space, move current element to a random position
and change the state of this space to `Initialized`
"""
function randomize!(space::AbstractSpace) end

######################################################
export AbstractSpaceTraverser, traverse

abstract type AbstractSpaceTraverser end

"""
    traverse(space) -> iterator

get an iterator that traverses the whole space.
"""
function traverse(space::AbstractSpace) end

################################
# Some default definitions
################################

reset!(space::AbstractSpace{T, UnRandomized}) where T = space
randomize!(space::AbstractSpace{T, Randomized}) where T = space

function shake!(space::AbstractSpace{T, UnRandomized}) where T
    throw(UnRandomizedError())
end
