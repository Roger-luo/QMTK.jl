# Absract

"""
Physics Constant are composite types have method value
All Physics Constant can be promoted to corresponding
subtype of `Number`
"""
abstract type AbstractPhysicsConst{T} <: Number end

import Base: promote_rule, convert, show, eltype

promote_rule(::Type{F}, ::Type{T}) where {F, T<:AbstractPhysicsConst} = promote_type(eltype(F), eltype(T))
convert(::Type{F}, x::T) where {F<:Number, T<:AbstractPhysicsConst} = convert(F, value(x))

show(io::IO, x::T) where {T <: AbstractPhysicsConst} = show(io, value(x))
