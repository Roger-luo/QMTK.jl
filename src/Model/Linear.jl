struct Linear{M<:AbstractMatrix, V<:AbstractVector} <: AbstractModel
    w::M
    b::V
end

forward(op::Linear, x) = op.w * x + op.b
backward(op::Linear, z, dz) = 0
