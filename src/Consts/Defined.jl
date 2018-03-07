###################
# Defined Constant
###################

struct DefConst{T} <: AbstractPhysicsConst{T}
    quantity::String
    value::T
    unit::String
end

value(x::DefConst) = x.value
eltype(::Type{DefConst{T}}) where T = T

export μ0, ε0

"""
magnetic constant (vacuum permeability)
"""
const μ0 = DefConst("magnetic constant (vacuum permeability)", 4pi*1e-7, "N A^{-2}")

"""
electric constant (vacuum permittivity)
"""
const ε0 = DefConst("electric constant (vacuum permittivity)", 1/(value(μ0)*value(c)^2), "F m^{-1}")
