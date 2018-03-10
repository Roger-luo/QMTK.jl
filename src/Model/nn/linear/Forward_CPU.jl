# Interface
# single input
function forward(op::Linear{T, Matrix{T}, Vector{T}, Vector{T}}, input::Vector{T}) where T
    op.input = input # NOTE: this is only a reference, no extra memmory alloc here
    BLAS.gemv('N', op.weight, input) + op.bias
end

# batched input
function forward(op::Linear{T, Matrix{T}, Vector{T}, Matrix{T}}, input::Matrix{T}) where T
    # NOTE: we use colum as a sample of data
    # PyTorch use the first dimension
    op.input = input
    return BLAS.gemm('N', 'N', op.weight, input) .+ op.bias # Be careful, here has a broadcast .+
end

# static array (immutable & mutable arrays)
# single input
function forward(op::Linear{T, M, B, I}, input::I) where {
        T,
        M<:StaticMatrix,
        B<:StaticVector,
        I<:StaticVector
    }
    
    op.input = input
    return op.weight * input + op.bias
end

# batched input
function forward(op::Linear{T, M, B, I}, input::I) where {
        T,
        M<:StaticMatrix,
        B<:StaticVector,
        I<:StaticMatrix
    }
    
    op.input = input
    return op.weight * input .+ op.bias
end
