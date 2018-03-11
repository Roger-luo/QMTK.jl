export SpaceState, Random, Initial

"""
state of a sample space: `Random`, `Initial`, etc.
"""
abstract type SpaceState end

"""
This sample space is randomized. (current sample is a initialized randomly)
"""
abstract type Random <: SpaceState end

"""
This sample space is initialized. (current sample is a certain default one)
"""
abstract type Initial <: SpaceState end

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

abstract type AbstractSpace{T, S<:SpaceState} end
israndomized(x::AbstractSpace{T, Random}) where {T} = true
israndomized(x::AbstractSpace{T, S}) where {T, S} = false

# Interface Definitions
export data, reset!, copy, acquire, shake!, randomize!

# Properties
function data end

# Basics
function reset! end
function copy end
function acquire end

# Random methods
function shake! end
function randomize! end

export AbstractSpaceTraverser, traverse

abstract type AbstractSpaceTraverser end
function traverse end

################################
# Some default definitions
################################

reset!(space::AbstractSpace{T, Initial}) where T = space
randomize!(space::AbstractSpace{T, Random}) where T = space

function shake!(space::AbstractSpace{T, Initial}) where T
    throw(UnRandomizedError())
end

include("Real.jl")
include("Sites.jl")
