export kronprod, ⊗, @kron

using QMTK.Consts.Pauli

⊗(A, B) = kron(A, B)

function kronprod(itr)
    state = start(itr)
    first, state = next(itr, state)
    second, state = next(itr, state)
    pd = kron(first, second)
    while !done(itr, state)
        val, state = next(itr, state)
        pd = kron(pd, val)
    end
    return pd
end

kronprod(m::SparseMatrixCSC...) = kronprod(m)
kronprod(m::Matrix...) = kronprod([sparse(each) for each in m])

#########
# @kron
#########

mutable struct KronProd
    n::Int # kron prod block size
    args::Vector{Pair} # matrix => index
end

KronProd() = KronProd(0, [])

# vector of matrix symbol to kron func
function vec2kron(seq::Vector)
    a, b = seq[1], seq[2]
    ex = Expr(:call, :kron, a, b)
    for each in seq[3:end]
        ex = Expr(:call, :kron, ex, each)
    end
    return ex
end

"""
    toexpr(expr)

interpret an expr contained `KronProd` to a normal
expression.
"""
function toexpr end

function toexpr(kronexpr::KronProd)
    seq = []
    previous = 0
    for (val, ind) in kronexpr.args
        for i = previous+1:ind-1
            push!(seq, :σ₀)
        end
        previous = ind
        push!(seq, val)
    end
    (val, ind) = kronexpr.args[end]
    if ind < kronexpr.n
        for i=ind+1:kronexpr.n
            push!(seq, :σ₀)
        end
    end
    return vec2kron(seq)
end

toexpr(sym::Symbol) = sym

function toexpr(expr::Expr)
    if !Meta.isexpr(expr, :call)
        return expr
    end

    for i in eachindex(expr.args)
        expr.args[i] = toexpr(expr.args[i])
    end
    return expr
end

import Base: show

# (3, sigmax[1], sigmax[3])
function show(io::IO, ex::KronProd)
    print(io, "($(ex.n), ")

    for i = 1:length(ex.args)-1
        (val, ind) = ex.args[i]
        print(io, "$val[$ind], ")
    end
    val, ind = ex.args[end]
    print(io, "$val[$ind])")
end

# interpret ⊗ symbol to KronProd
function kron_otimes!(p::KronProd, expr::Expr)
    if Meta.isexpr(expr, :ref)
        val, index = expr.args
        push!(p.args, val=>index)
        if p.n < index
            p.n = index
        end
    end
    
    if expr.args[1] in (:⋅, :⊗)
        a, b = expr.args[2:end]
        kron_otimes!(p, a)
        kron_otimes!(p, b)
    else
        return p
    end
    return p
end

# interpret Expr to KronProd
function kronprod(expr::Expr)
    ex = KronProd()
    if expr.args[1] == :*
        seq = expr.args[2:end]
        sort!(seq, by = x -> x.args[2])

        for each in seq
            val, index = each.args
            push!(ex.args, val=>index)
            if ex.n < index
                ex.n = index
            end
        end
    elseif expr.args[1] in (:⋅, :⊗)
        kron_otimes!(ex, expr)
        sort!(ex.args, by = x->x.second)
    end
    return ex
end

# sync all KronProd size to total
function sync_total!(args, i, total)
    for each in args[1:i]
        if isa(each, KronProd)
            each.n = total
        end
    end
end

# interpret kronecker plus
function kronplus(expr::Expr)
    _total = 0
    for i = 2:length(expr.args)
        ex = _kron_expr(expr.args[i])
        if isa(ex, KronProd)
            if ex.n > _total
                _total = ex.n
                sync_total!(expr.args, i, _total)
            else
                ex.n = _total
            end
        end
        expr.args[i] = ex
    end
    return expr
end

# interpret to expr contains KronProd
function _kron_expr(expr::Expr)
    if !Meta.isexpr(expr, :call)
        return expr
    end

    if expr.args[1] in (:+, :-)
        return kronplus(expr)
    elseif expr.args[1] in (:*, :⋅, :⊗)
        return kronprod(expr)
    end
end

# parse expr
function _kron(expr::Expr)
    ex = _kron_expr(expr)
    return toexpr(ex)
end

"""
    @kron expr

this macro will interpret all multiplication operator
(*, ``\\cdot``, ``\\otimes``) into kronecker product, and
it will interpret all plus or minus operator (+, -) into
kronecker plus/minus according to the index inside ref.

## Example

```math
\\sigma_1^1\\sigma_3^3 + \\sigma_1^2\\sigma_2^4
```

is equivalent to

```julia
@kron σ₁[1] ⊗ σ₃[3] + σ₁[2] ⊗ σ₂[4]
@kron σ₁[1] * σ₃[3] + σ₁[2] * σ₂[4]
@kron σ₁[1] ⋅ σ₃[3] + σ₁[2] ⋅ σ₂[4]
kronprod(σ₁, σ₀, σ₃, σ₀) + kronprod(σ₀, σ₁, σ₀, σ₂)
```
"""
macro kron(expr)
    _kron(expr)
end