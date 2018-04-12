grad_abs(x::T) where {T<:Real} = sign(x)
grad_abs(z::T) where {T<:Complex} = exp(-im * angle(z))


# NAME, forward, backward (for real)
__NON_HOLOMOPHICS__ = [
    (:RealOp, x->:(real.($x))),
    (:ImagOp, x->:(imag.($x))),
    (:Conj, x->:(conj.($x))),
    (:Abs, x->:(abs.($x))),
    (:Abs2, x->:(abs.($x))),
    (:Arg, x->:(angle.($x))),
    (:Sign, x->:(sign.($x)))
]

for (OP, FUNC) in __NON_HOLOMOPHICS__

    @eval begin
        mutable struct $OP{T, O} <: AbstractBlock
            input::O
            $OP{T, O}() where {T, O} = new{T, O}()
        end

        $OP(::Type{T}, ::Type{O}) where {T, O} = $OP{T, O}()
        $OP(::Type{T};nbatch=1) where T = $OP(T, nbatch > 1 ? Matrix{T} : Vector{T})
        $OP(;nbatch=1) = $OP(Float64, nbatch=nbatch)

        function forward(op::$OP{T, O}, input::O) where {T, O}
            op.input = input
            return $(FUNC(:(input)))    
        end
    end

end

function backward(op::RealOp{T, O}, grad::O) where {T <: Real, O}
    return grad
end

function backward(op::RealOp{T, O}, grad::O) where {T <: Complex, O}
    return real(grad)
end

function backward(op::ImagOp{T, O}, grad::O) where {T <: Real, O}
    return zeros(grad)
end

function backward(op::ImagOp{T, O}, grad::O) where {T <: Complex, O}
    return -im .* real(grad)
end

function backward(op::Conj{T, O}, grad::O) where {T <: Real, O}
    return grad
end

function backward(op::Conj{T, O}, grad::O) where {T <: Complex, O}
    return conj(grad)
end

function backward(op::Abs{T, O}, grad::O) where {T <: Real, O}
    return grad .* sign(op.input)
end

function backward(op::Abs{T, O}, grad::O) where {T <: Complex, O}
    return real(grad) .* exp.(-im .* op.input)
end

function backward(op::Abs2{T, O}, grad::O) where {T <: Real, O}
    return 2 .* grad .* op.input
end

function backward(op::Abs2{T, O}, grad::O) where {T <: Complex, O}
    return 2 .* real(grad) .* conj(op.input)
end

function backward(op::Arg{T, O}, grad::O) where {T <: Real, O}
    error("Do not support real number")
end

function backward(op::Arg{T, O}, grad::O) where {T <: Complex, O}
    return -im ./ op.input .* real(grad)
end

function backward(op::Sign{T, O}, grad::O) where {T <: Real, O}
    throw(ErrorException("you cannot use Sign for real gradient"))
end

function backward(op::Sign{T, O}, grad::O) where {T <: Complex, O}
    s = exp.(im .* angle(op.input))
    conj(s) ./ abs.(op.input) .* im .* imag.(s .* grad)
end
