# Real Space

export RealSpace

const RealSpaceType{T} = Union{T, Array{T, N} where N}

mutable struct RealSpace{T<:Real, DType<:RealSpaceType{T}, S} <: AbstractSpace{T, S}
    min::T
    max::T
    data::DType
end

# Utils
_uniform(min, max) = _uniform(Float64, min, max)
_uniform(shape::Tuple, min, max) = _uniform(Float64, shape, min, max)
_uniform(::Type{T}, min, max) where T = T(max - min) * rand(T) + T(min)
_uniform(::Type{T}, shape::Tuple, min, max) where T = T(max-min) * rand(T, shape) + T(min)

# Constructors
RealSpace(;min=0, max=1) = RealSpace(Float64, min=min, max=max)
RealSpace(shape::Integer...; min=0, max=1) = RealSpace(Float64, shape, min=min, max=max)
RealSpace(::Type{T}, shape::Integer...; min=0, max=1) where T = RealSpace(T, shape, min=min, max=max)

# Basic Constructors
RealSpace(::Type{T}; min=0, max=1) where T = RealSpace{T, T, Random}(min, max, _uniform(T, min, max))
RealSpace(::Type{T}, shape::Tuple; min=0, max=1) where T =
    RealSpace{T, Array{T, length(shape)}, Random}(min, max, _uniform(T, shape, min, max))

RealSpace(::Type{S}, space::RealSpace{T, D}) where {T, D, S} = RealSpace{T, D, S}(space.min, space.max, space.data)

function reset!(space::RealSpace{T, D, Random}) where {T, D <: AbstractArray}
    fill!(space.data, space.min)
    return RealSpace(Initial, space)
end

function reset!(space::RealSpace{T, D, Random}) where {T, D <: Real}
    space.data = space.min
    return RealSpace(Initial, space)
end

copy(space::RealSpace{T, D, S}) where {T, D <: Real, S} =
    RealSpace{T, D, S}(space.min, space.max, space.data)
copy(space::RealSpace{T, D, S}) where {T, D <: AbstractArray, S} =
    RealSpace{T, D, S}(space.min, space.max, copy(space.data))

acquire(space::RealSpace{T, D, S}) where {T, D <: Real, S} = space.data
acquire(space::RealSpace{T, D, S}) where {T, D <: AbstractArray, S} = copy(space.data)

traverse(space::RealSpace, step::Real=1e-2) = RealTraverser(space, step)

import Base: start, next, done

struct RealTraverser{T, D}
    data::RealSpace{T, D}
    step::T
end

# TODO: traverse array field
start(itr::RealTraverser{T, D}) where {T, D <: Real} = 1
next(itr::RealTraverser{T, D}, state) where {T, D <: Real} = (itr.data.min + state * step, state + 1)
done(itr::RealTraverser{T, D}, state) where {T, D <: Real} = itr.data.min + state * step > itr.data.max

# Properties
data(space::RealSpace) = space.data

# Randomize methods
# Note: shake! will be dispatched, we use a temperory function

@inline function _shake!(space::RealSpace{T, DType}) where {T, DType <: Real}
    space.data = (space.max - space.min) * rand() + space.min
end

@inline function _shake!(space::RealSpace{T, DType}) where {T, DType <: AbstractArray}
    rand!(space.data)
    space.data.*= (space.max - space.min)
    space.data.+= space.min
    return space.data
end

shake!(space::RealSpace{T, D, Random}) where {T, D} = _shake!(space)

function randomize!(space::RealSpace{T, D, Initial}) where {T, D}
    _shake!(space)
    return RealSpace(Random, space)
end
