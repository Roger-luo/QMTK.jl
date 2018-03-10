grad_abs(x::T) where {T<:Real} = sign(x)
grad_abs(z::T) where {T<:Complex} = exp(-im * angle(z))


__NON_HOLOMOPHICS__ = [
    (:RealOp, x->:(real.($x)), x->:(real.($x))), # TO CHECK
    (:ImagOp, x->:(imag.($x)), x->:(-im .* real.($x))),
    (:Conj, x->:(conj.($x)), x->:(conj.($x))),
    (:Abs, x->:(abs.($x)), x->:(grad_abs.($x))),
    (:SquareAbs, x->:(abs.($x) .* abs.($x)), x->:()),
]

for (OP, FUNC, DFUNC) in __NON_HOLOMOPHICS__

    @eval begin
        mutable struct $OP{T, O} <: AbstractBlock
            output::O
            $OP{T, O}() where {T, O} = new{T, O}()
        end

        $OP(::Type{T}, ::Type{O}) where {T, O} = $OP{T, O}()
        $OP(::Type{T};nbatch=1) where T = $OP(T, nbatch > 1? Matrix{T} : Vector{T})
        $OP(;nbatch=1) = $OP(Float64, nbatch=nbatch)

        function forward(op::$OP{T, O}, input::O) where {T, O}
            op.output = $(FUNC(:(input)))    
            return op.output
        end

        function backward(op::$OP{T, O}, grad::O) where {T <: Real, O}
            grad .* $(DFUNC(:(op.output)))
        end
    end

end

function backward(op::RealOp{T, O}, grad::O) where {T <: Complex, O}
    return real(grad)
end

function backward(op::ImagOp{T, O}, grad::O) where {T <: Complex, O}
    return -im .* real(grad)
end

function backward(op::Conj{T, O}, grad::O) where {T <: Complex, O}
    return conj(grad)
end

function backward(op::Abs{T, O}, grad::O) where {T <: Complex, O}
    return real(grad) .* exp.(-im .* op.output)
end

function backward(op::SquareAbs{T, O}, grad::O) where {T <: Complex, O}
    return 2 .* real(grad) .* conj(op.output)
end
