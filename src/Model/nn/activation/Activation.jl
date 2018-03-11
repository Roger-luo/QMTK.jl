# TODO: optimize sigmoid and etc. with threshold


"""
    __BASIC_ACTIVATIONS__

a collection of activations with no parameter and only one input.
"""
__BASIC_ACTIVATIONS__ = [
    (:Sin, x->:(sin.($x)), x->:(cos.($x))),
    (:Cos, x->:(cos.($x)), x->:(-sin.($x))),
    (:Sinh, x->:(sinh.($x)), x->:(cosh.($x))),
    (:Cosh, x->:(cosh.($x)), x->:(-sinh.($x))),
    (:Tan, x->:(tan.($x)), x->:(sec.($x) .* sec.($x))),
    (:Tanh, x->:(tanh.($x)), x->:(sec.($x) .* tan.($x))),
    (:Csc, x->:(csc.($x)), x->:(-csc.($x) .* cot.($x))),
    (:Cot, x->:(cot.($x)), x->:(-csc.($x) .* csc.($x))),
    (:ArcSin, x->:(asin.($x)), x->:(1 ./ sqrt(1 .- ($x .* $x)))),
    (:ArcCos, x->:(acos.($x)), x->:(-1 ./ sqrt(1 .- ($x .* $x)))),
    (:ArcTan, x->:(atan.($x)), x->:(1 ./ (1 .+ ($x .* $x)))),
    (:Exp, x->:(exp.($x)), x->:(exp.($x))),
    (:Log, x->:(log.($x)), x->:(1 ./ $x)),
]


for (OP, FUNC, DFUNC) in __BASIC_ACTIVATIONS__
    @eval begin
        export $OP

        mutable struct $OP{T, O} <: AbstractBlock
            input::O
            $OP{T, O}() where {T, O} = new{T, O}()
        end

        $OP(::Type{T}, ::Type{O}) where {T, O} = $OP{T, O}()
        $OP(::Type{T};nbatch=1) where T = $OP(T, nbatch > 1? Matrix{T} : Vector{T})
        $OP(;nbatch=1) = $OP(Float64, nbatch=nbatch)

        function forward(op::$OP{T, O}, input::O) where {T, O}
            op.input = input
            return $(FUNC(:(input)))    
        end

        function backward(op::$OP{T, O}, grad::O) where {T, O}
            grad .* $(DFUNC(:(op.input)))
        end
    end
end

include("Complex.jl")
include("Sigmoid.jl")
include("PReLU.jl")
include("ReLU.jl")
include("Gaussian.jl")
