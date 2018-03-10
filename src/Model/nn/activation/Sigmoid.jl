"""
"""
mutable struct Sigmoid{T<:AbstractVecOrMat} <: AbstractBlock
    output::T
    Sigmoid{T}() where T = new()
end

Sigmoid(::Type{T}) where {T<:AbstractVecOrMat} =
    Sigmoid{T}()

Sigmoid(;nbatch=1) = Sigmoid(nbatch > 1? Vector : Matrix)

function forward(op::Sigmoid{CPU, T}, input::T) where {T <: AbstractVecOrMat}
    op.output = 1 ./ (1 + exp(-input))
    return op.output
end

function backward(op::Sigmoid{CPU, T}, grad::T) where {T <: AbstractVecOrMat}
    grad .* (1.0 .- op.output) .* op.output
end
