export DefConst

struct DefConst{T} <: AbstractPhysicsConst{T}
    quantity::String
    value::T
    unit::String
end

value(x::DefConst) = x.value
eltype(::Type{DefConst{T}}) where T = T
