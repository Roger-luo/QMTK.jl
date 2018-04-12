export Linear

const WeightType{T} = AbstractMatrix{T}
const BiasType{T} = Union{Compat.Nothing, AbstractVector{T}}

"""
    Linear{T, WeightType, BiasType, InputType} <: AbstractBlock

Linear layer.

``z^{l+1} = W^l * z^{l} + b^l``

expression of gradients:

``\\delta^{l} = (W^l)^T\\delta^{l+1}``
``\\delta^{l}_w = \\delta^{l+1}(z^l)^T``
``\\delta^{l}_b = \\delta^{l+1}``
"""
mutable struct Linear{
                        T, # Numeric Type
                        WType<:WeightType{T},
                        BType<:BiasType{T},
                        IType<:AbstractVecOrMat{T}
                    } <: AbstractBlock

    weight::WType
    bias::BType

    grad_weight::WType
    grad_bias::BType

    input::IType

    function Linear{T, W, B, I}(
        weight::W,
        bias::B,
        grad_weight::W,
        grad_bias::B
        ) where {T, W, B, I}
        new{T, W, B, I}(weight, bias, grad_weight, grad_bias)
    end
end

include("Utils.jl")
include("Constructor.jl")
include("Forward.jl")
include("Backward.jl")

import Base: show

function show(io::IO, op::Linear)
    dname = string(device(op.weight))
    print(io, "Linear{$(dname)} ($(size(op, 1)) -> $(size(op, 2)))")
end
