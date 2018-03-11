# enable type inference for constructor
Linear(::Type{T}, ::Type{I}, weight::W, bias::B) where {T, I, W, B} =
    Linear{T, W, B, I}(weight, bias, zeros(weight), bias === nothing ? nothing : zeros(bias))

Linear(weight::WeightType{T}, bias::BiasType{T}; nbatch=1) where {T} =
    Linear(T, linear_input_type(weight, nbatch), weight, bias)
Linear(weight::WeightType{T}; nbatch=1) where {T} =
    Linear(weight, nothing; nbatch=nbatch)

import Base: size

size(op::Linear) = size(op.weight)
size(op::Linear, d::Int) = reverse(size(op.weight))[d]

function size(op::Linear, d::Symbol)
    if d == :input
        return size(op, 1)
    elseif d == :output
        return size(op, 2)
    else
        # TODO: custom exception
        throw(ErrorException("Invalid tag, Linear layer's 
        size tag should be :input or :output"))
    end
end

function zerograd!(op::Linear)
    fill!(op.grad_weight, 0)
    op.grad_bias === nothing ? fill!(op.bias, 0) : nothing
    return op
end

function initialize!(op::Linear)
    stdv = 1 / sqrt(size(op.weight, 1))
    rand!(op.weight)
    op.weight = stdv * (2 * op.weight - 1) # stdv * uniform(-1, 1)

    if op.bias !== nothing
        rand!(op.bias)
        op.bias = stdv * (2 * op.bias - 1)
    end
    return op
end

# Initialization
function Linear(::Type{T}, in_features::Int, out_features::Int;bias=true, nbatch=1) where T
    op = Linear(zeros(T, out_features, in_features), bias ? zeros(T, out_features) : nothing; nbatch=nbatch)
    return initialize!(op)
end

Linear(::Type{T}, shape::Tuple{Int, Int};bias=true, nbatch=1) where T =
    Linear(T, shape...; bias=bias, nbatch=nbatch)

Linear(shape::Tuple{Int, Int};bias=true, nbatch=1) =
    Linear(Float64, shape; bias=bias, nbatch=nbatch)
Linear(shape::Int...;bias=true, nbatch=1) =
    Linear(shape;bias=bias, nbatch=nbatch)

# TODO: use static array when the layer is small, benchmark needed for this
