import QMTK: backward

# CPU
# single sample
function backward(op::Linear{T, Matrix{T}, Vector{T}, Vector{T}}, grad::Vector{T}) where T
    tInput = reshape(op.input, size(op.input, 1), 1)
    tgrad = reshape(grad, size(grad, 1), 1)
    BLAS.gemm!('N', 'T', one(T), tgrad, tInput, one(T), op.grad_weight)

    if op.grad_bias !== nothing
        op.grad_bias .= grad
    end

    return BLAS.gemv('T', op.weight, grad)
end

# batched sample
function backward(op::Linear{T, Matrix{T}, Vector{T}, Matrix{T}}, grad::Matrix{T}) where T
    tgrad = reshape(grad, size(grad, 1), 1, size(grad, 2))
    tInput = reshape(op.input, size(op.input, 1), 1, size(op.input, 2))
    op.grad_weight += bmm('N', 'T', tgrad, tInput)

    if op.grad_bias !== nothing
        sum!(op.grad_bias, grad)
    end

    return BLAS.gemm('T', 'N', op.weight, grad)
end
