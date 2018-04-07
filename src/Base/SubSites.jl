export SubSites

"""
    SubSites{Label, T, Length} <: AbstractSites{Label, T, 1}

Sub-sites is usually derived from `Sites`. It contains several sites in
a tuple for local operations.

NOTE: SubSites should be designed faster for bitwise operations, cause this
will be a temperory type for traversing through lattice.
"""
mutable struct SubSites{Label, T, Length} <: AbstractSites{Label, T, 1}
    data::NTuple{Length, T}
end

SubSites(::Type{L}, data::T...) where {L, T} = SubSites(L, data)
SubSites(::Type{L}, data::NTuple{Length, T}) where {L, Length, T} = 
    SubSites{L, T, Length}(data)
SubSites(::Type{L}, ::Type{DT}, data::T...) where {L, DT, T} =
    SubSites(L, DT, data)
SubSites(::Type{L}, ::Type{DT}, data::NTuple{Length, T}) where {L, DT, Length, T} =
    SubSites{L, DT, Length}(data)

sitetype(::Type{SubSites{Label, T, Length}}) where {Label, T, Length} = Label
data(s::SubSites) = s.data

import Base: show

function show(io::IO, x::SubSites{L, T, N}) where {L, T, N}
    print(io, "SubSites{$L, $T, $N}")
    print(io, x.data)
end

# use array interface
import Base: eltype, length, ndims, size, eachindex, 
    getindex, setindex!, stride, strides, copy, indices
import Compat: axes

eltype(x::SubSites{L, T, N}) where {L, T, N} = T
length(x::SubSites{L, T, N}) where {L, T, N} = N
ndims(x::SubSites{L, T, N}) where {L, T, N} = 1
size(x::SubSites{L, T, N}) where {L, T, N} = (N, )
size(x::SubSites{L, T, N}, n::Integer) where {L, T, N} = n == 1? N : 1
# axes(x::SubSites{L, T, N}) where {L, T, N} = (1:N, )
# axes(x::SubSites{L, T, N}, d::Integer) where {L, T, N} = d == 1? 1:N : 1:1
eachindex(x::SubSites{L, T, N}) where {L, T, N} = eachindex(x.data)
stride(x::SubSites{L, T, N}, k::Integer) where {L, T, N} = k == 1? 1 : N
strides(x::SubSites{L, T, N}) where {L, T, N} = (1, )

getindex(x::SubSites, index::Integer) = getindex(x.data, index)
function getindex(x::SubSites, index::Integer...)
    if all(Base.tail(index) .!= 1)
        throw(BoundsError(x, index))
    end
    getindex(x.data, first(index))
end

# Iterator Interface
import Base: start, next, done, eltype, length

start(x::SubSites) = start(x.data)
next(x::SubSites, state) = next(x.data, state)
done(x::SubSites, state) = done(x.data, state)

# Conversion
import Base: convert

@generated function convert(::Type{SubSites{Bit, T, L}}, n::Int) where {T, L}
    ex = Expr(:call, :SubSites, :Bit)
    for i = 0:L-1
        push!(ex.args, :($T((n>>$i) & 0x01)))
    end
    return ex
end

@generated function convert(::Type{D}, x::SubSites{Bit, T, L}) where {D <: Integer, T, L}
    ex = :(x[1] * 1)
    for i = 2:L
        factor = 2^(i-1)
        ex = :(x[$i] * $factor + $ex)
    end
    return :(D($ex))
end

@generated function convert(::Type{SubSites{Spin, T, L}}, n::Int) where {T, L}
    ex = Expr(:call, :SubSites, :Spin)
    for i = 0:L-1
        push!(ex.args, :($T(2 * ((n>>$i) & 1) - 1)))
    end
    return ex
end

@generated function convert(::Type{D}, x::SubSites{Spin, T, L}) where {D <: Integer, T, L}
    ex = :(div(x[1]+1, 2) * 1)
    for i = 2:L
        factor = 2^(i-1)
        ex = :(div(x[$i] + 1, 2) * $factor + $ex)
    end
    return :(D($ex))
end

@generated function convert(::Type{SubSites{Half, T, L}}, n::Int) where {T, L}
    ex = Expr(:call, :SubSites, :Half)
    for i = 0:L-1
        push!(ex.args, :($T(((n>>$i) & 1) - 0.5)))
    end
    return ex
end

@generated function convert(::Type{D}, x::SubSites{Half, T, L}) where {D <: Integer, T, L}
    ex = :((x[1]+0.5) * 1)
    for i = 2:L
        factor = 2^(i-1)
        ex = :((x[$i]+0.5) * $factor + $ex)
    end
    return :(D($ex))
end

function convert(::Type{SubSites{Half, TA, L}}, x::SubSites{Spin, TB, L}) where {TA, TB, L}
    return SubSites{Half, TA, L}(x.data ./ 2)
end

function convert(::Type{SubSites{Half, TA, L}}, x::SubSites{Bit, TB, L}) where {TA, TB, L}
    return SubSites{Half, TA, L}(x.data .- 0.5)
end

function convert(::Type{SubSites{Spin, TA, L}}, x::SubSites{Half, TB, L}) where {TA, TB, L}
    return SubSites{Spin, TA, L}(x.data .* 2)
end

function convert(::Type{SubSites{Spin, TA, L}}, x::SubSites{Bit, TB, L}) where {TA, TB, L}
    return SubSites{Spin, TA, L}(x.data.*2 .- 1)
end

function convert(::Type{SubSites{Bit, TA, L}}, x::SubSites{Spin, TB, L}) where {TA, TB, L}
    return SubSites{Bit, TA, L}((x.data .+ 1) ./ 2)
end

function convert(::Type{SubSites{Bit, TA, L}}, x::SubSites{Half, TB, L}) where {TA, TB, L}
    return SubSites{Bit, TA, L}(x.data .+ 0.5)
end
