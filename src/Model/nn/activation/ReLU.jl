struct ReLU{T, O} <: AbstractBlock
    input::O
    ReLU{T, O}() = new{T, O}()
end

ReLU(::Type{T}, ::Type{O}) where {T, O} = ReLU{T, O}()
ReLU(::Type{O}) where O = ReLU{Float64, O}()
ReLU(::Type{T};nbatch=1) where T = ReLU(T, nbatch > 1? Matrix{T} : Vector{T})
ReLU(;nbatch=1) = ReLU(Float64; nbatch=nbatch)

_relu(x::T) where {T <: Real} = x > 0 ? x : 0
_relu_grad(x::T, grad::T) where {T <: Real} = x > 0 ? grad : 0

function _relu(x::T) where {T <: Complex}
    if real(x) > 0 && imag(x) > 0
        return x
    elseif real(x) > 0 && imag(x) < 0
        return real(x)
    elseif real(x) < 0 && imag(x) > 0
        return imag(x)
    else
        return 0
    end
end

function _relu_grad(x::T, grad::T) where {T <: Complex}
    if real(x) > 0 && imag(x) > 0
        return grad
    elseif real(x) > 0 && imag(x) < 0
        return real(grad)
    elseif real(x) < 0 && imag(x) > 0
        return -im * real(grad)
    else
        return 0
    end
end

function forward(op::ReLU{T, O}, input::O) where {T, O}
    return _relu.(input)
end

function backward(op::ReLU{T, O}, grad::O) where {T, O}
    return _relu_grad.(op.input, grad)
end
