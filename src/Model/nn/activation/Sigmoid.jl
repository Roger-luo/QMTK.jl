# TODO: use threshold to optimize and avoid infinity

export Sigmoid

"""
"""
mutable struct Sigmoid{T, O} <: AbstractBlock
    output::O
    Sigmoid{T, O}() where {T, O} = new{T, O}()
end

Sigmoid(::Type{T}, ::Type{O}) where {T, O} =
    Sigmoid{T, O}()

Sigmoid(::Type{T}; nbatch=1) where T = Sigmoid(T, nbatch > 1 ? Matrix{T} : Vector{T})
Sigmoid(;nbatch=1) = Sigmoid(Float64; nbatch=nbatch)

function forward(op::Sigmoid{T, O}, input::O) where {T, O}
    op.output = 1 ./ (1 + exp(-input))
    return op.output
end

function backward(op::Sigmoid{T, O}, grad::O) where {T <: Real, O}
    grad .* (1.0 .- op.output) .* op.output
end
