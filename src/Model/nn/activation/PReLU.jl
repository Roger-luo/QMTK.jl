mutable struct PReLU{T, W, O} <: AbstractBlock
    weight::W
    output::O
    PReLU{T, W, O}(weight::W) where {T, W, O} = new{T, W, O}(weight)
end

PReLU(::Type{T}, ::Type{O}, weight::W) where {T, W, O} = PReLU{T, W, O}(weight)

PReLU(::Type{T}, weight::W; nbatch=1) where {T, W} =
    PReLU(T, nbatch > 1 ? Matrix{T} : Vector{T}, weight)
PReLU(weight::T;nbatch=1) where T = PReLU(T, weight; nbatch=nbatch)
PReLU(::Type{T};nbatch=1, init=0.25, nparam=1) where T =
    PReLU(nparam > 1 ? fill(T(init), nparam) : T(init);nbatch=nbatch)
PReLU(;nbatch=1, init=0.25, nparam=1) =
    PReLU(Float64; nbatch=nbatch, init=init, nparam=nparam)

_prelu(x::T, w::T) where {T <: Real} = x > 0 ? x : w * x
_prelu_grad(x::T, dx::T, w::T) where {T <: Real} = x > 0 ? dx : w * dx

# single output plane
function forward(op::PReLU{T, T, O}, input::O) where{T <: Real, O}
    return _prelu.(input, op.weight)    
end

function backward(op::PReLU{T, T, O}, grad::O) where {T <: Real, O}
    return _prelu_grad.(op.input, grad, op.weight)
end

# TODO: multiple output plane, ref: THNN/generic/PReLU.c
# TODO: complex PReLU