export AbstractKet, Ket

"""
    AbstractKet{S <: AbstractTag}

Any type with `LHS` or `RHS` tag is a ket object. It should
support `dot` operation that raise an error when `LHS` and `RHS`
is in wrong order
"""
abstract type AbstractKet{S <: AbstractTag} end

import Base: show
import Compat.LinearAlgebra: dot

dot(rhs::AbstractKet{RHS}, lhs::AbstractKet{LHS}) =
    throw(TypeError(:dot, "wrong order of kets", LHS, RHS))

# A Naive Implementation
mutable struct Ket{T, S <: AbstractTag} <: AbstractKet{S}
    data::T
end

Ket(::Type{S}, data::T) where {T, S} = Ket{T, S}(data)

show(io::IO, ket::Ket{T, S}) where {T, S} = print(io, "Ket{$T, $S}")
dot(lhs::Ket{LT, LHS}, rhs::Ket{RT, RHS}) where {LT, RT} =
    dot(lhs.data, rhs.data)
