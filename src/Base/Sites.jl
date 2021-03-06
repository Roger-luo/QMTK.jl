export Sites

"""
    Sites{L <: SiteLabel, T, N} <: AbstractSites{L, T, N}

Lattice Sites are Julia Arrays with certain Label, it is able to use array
interface.

TODO: type promote to normal arrays when mixed with normal arrays.
"""
mutable struct Sites{L <: SiteLabel, T, N} <: AbstractSites{L, T, N}
    data::Array{T, N}
end

# Enable type inference
Sites(::Type{L}, data::Array{T, N}) where {L, T, N} = Sites{L, T, N}(data)

Sites(::Type{L}, shape::Int...) where L <: SiteLabel = Sites(L, shape)
Sites(::Type{L}, shape::Tuple) where L <: SiteLabel =
    Sites{L, eltype(L), length(shape)}(fill(down(L), shape))

data(s::Sites) = s.data

# use array interface
import Base: eltype, length, ndims, size, eachindex, 
    getindex, setindex!, stride, strides, copy
import Compat: axes

eltype(x::Sites{L, T}) where {L, T} = T
length(x::Sites) = length(x.data)
ndims(x::Sites) = ndims(x.data)
size(x::Sites) = size(x.data)
size(x::Sites, n::Integer) = size(x.data, n)
axes(x::Sites) = axes(x.data)
axes(x::Sites, d::Integer) = axes(x.data, d)
eachindex(x::Sites) = eachindex(x.data)
stride(x::Sites, k::Integer) = stride(x.data, k)
strides(x::Sites) = strides(x.data)
getindex(x::Sites, index::Integer...) = getindex(x.data, index...)
getindex(x::Sites, index::NTuple{N, T}) where {N, T <: Integer} = getindex(x.data, index...)
setindex!(x::Sites, val, index::Integer...) = setindex!(x.data, val, index...)
setindex!(x::Sites, val, index::NTuple{N, T}) where {N, T <: Integer} = setindex!(x.data, val, index...)

@inline function copy(b::Sites{L, T, N}) where {L, T, N}
    return Sites{L, T, N}(copy(b.data))
end

sitetype(::Type{Sites{L}}) where L = L
sitetype(x::Sites{L}) where L = L

export reset!, set!

@inline function reset!(b::Sites{L, T, N}) where {L, T, N}
    fill!(b.data, down(L))
    return b
end

@inline function set!(s::Sites{Bit, T, N}, n::Int) where {T, N}
    for i in eachindex(s)
        @inbounds s[i] = ((n>>(i-1)) & 0x1)
    end
    return s
end

@inline function set!(s::Sites{Spin, T, N}, n::Int) where {T, N}
    for i in eachindex(s)
        @inbounds s[i] = 2 * ((n>>(i-1)) & 0x1) - 1
    end
    return s
end

@inline function set!(s::Sites{Half, T, N}, n::Int) where {T, N}
    for i in eachindex(s)
        @inbounds s[i] = ((n>>(i-1)) & 0x1) - 0.5
    end
    return s
end

#######################
# randomize interface
#######################

function rand!(rng::AbstractRNG, b::Sites{L, T, N}) where {L, T, N}
    rand!(rng, b.data, [up(L), down(L)])
    return b
end

rand!(b::Sites{L, T, N}) where {L <: SiteLabel, T, N} = rand!(GLOBAL_RNG, b)
rand(rng::AbstractRNG, ::Type{L}, shape::Dims) where {L <: SiteLabel} = 
    rand!(rng, Sites(L, shape))

####################

@inline function flip!(b::Sites{L, T, N}, index::Integer...) where {L, T, N}
    if b[index...] == up(L)
        b[index...] = down(L)
    else
        b[index...] = up(L)
    end
    return b
end

@inline function randflip!(b::Sites{L, T, N}) where {L, T, N}
    offset = rand(1:length(b))
    return flip!(b, offset)
end

# carry bit
function carrybit!(a::Sites{L}) where L
    for i in eachindex(a)
        if a[i] == up(L)
            a[i] = down(L)
        else
            a[i] = up(L)
            break
        end
    end
end

# TODO: whether this should have side effect?
# will side effect affects performance (extra instance)?
import Base: <<
function <<(a::Sites, b::Int)
    for i = 1:b
        carrybit!(a)
    end
    return a
end

##############
# Conversions
##############

import Base: convert

function convert(::Type{Integer}, x::Sites{L, T, N}) where {L, T, N} end

for IntType in (:Int8, Int16, Int32, Int64, Int128, BigInt)
@eval begin
        function convert(::Type{$IntType}, x::Sites{Bit, T, N}) where {T, N}
            if sizeof($IntType) * 8 < length(x)
                throw(Compat.InexactError(:convert, $IntType, x))
            end

            sum($IntType(each) << (i-1) for (i, each) in enumerate(x))
        end

        function convert(::Type{$IntType}, x::Sites{Spin, T, N}) where {T, N}
            if sizeof($IntType) * 8 < length(x)
                throw(Compat.InexactError(:convert, $IntType, x))
            end

            sum($IntType(div(each+1, 2)) << (i-1) for (i, each) in enumerate(x))
        end

        function convert(::Type{$IntType}, x::Sites{Half, T, N}) where {T, N}
            if sizeof($IntType) * 8 < length(x)
                throw(Compat.InexactError(:convert, $IntType, x))
            end

            sum($IntType(each+0.5) << (i-1) for (i, each) in enumerate(x))
        end
    end
end
