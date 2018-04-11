module Kronecker
export kronprod, ⊗, kronparse, toexpr, @kron

import QMTK: LatticeIterator, getid
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

kronprod(m::AbstractMatrix...) = kronprod(m)

#########
# @kron
#########
using DataStructures

abstract type KronExpr end

import Base: length
length(x::KronExpr) = x.len

mutable struct MatExpr
    expr
    index::Int
end

MatExpr(p::Pair) = MatExpr(p.first, p.second)

function MatExpr(e::Expr)
    if Meta.isexpr(e, :ref)
        return MatExpr(e.args[1], e.args[2])
    else
        throw(ParseError(
            "expects square brackets after matrix: matrix[index]"
        ))
    end
end

import Base: convert
convert(::Type{MatExpr}, src::Pair) = MatExpr(src)

import Base: isless
isless(x::MatExpr, y::MatExpr) = isless(x.index, y.index)


mutable struct KronProd <: KronExpr
    len::Int
    args::Vector{MatExpr}
end

KronProd() = KronProd(0, [])

function setlen!(ex::KronProd, len::Int)
    ex.len = len
    return ex
end

function KronProd(seq::Vector{MatExpr})
    total = 0
    for each in seq
        if total < each.index
            total = each.index
        end
    end
    return KronProd(total, heapify(seq))
end

abstract type DirectPlus end
abstract type DirectMinus end

mutable struct BinaryExpr{OP, LHS <: KronExpr, RHS <: KronExpr} <: KronExpr
    len::Int
    left::LHS
    right::RHS
end

function setlen!(ex::BinaryExpr, len::Int)
    setlen!(ex.left, len)
    setlen!(ex.right, len)
    return ex
end

function BinaryExpr(::Type{OP}, lhs::LHS, rhs::RHS) where {OP, LHS, RHS}
    len = max(lhs.len, rhs.len)
    setlen!(lhs, len)
    setlen!(rhs, len)
    BinaryExpr{OP, LHS, RHS}(len, lhs, rhs)
end

#######################
# show
#######################
import Base: show

function show(io::IO, ex::MatExpr)
    print(io, "$(ex.expr)[$(ex.index)]")
end

function show(io::IO, ex::KronProd)
    seq = copy(ex.args)
    print(io, "kron($(ex.len), ")
    count = 1
    while !isempty(seq)
        each = heappop!(seq)
        print(io, "$each")
        if count < length(ex.args)
            print(io, " ⊗ ")
        end
        count += 1
    end
    print(io, ")")
end

function show(io::IO, ex::BinaryExpr{DirectPlus})
    print(io, "$(ex.left)")
    print(io, " ⊕ ")
    print(io, "$(ex.right)")
end

function show(io::IO, ex::BinaryExpr{DirectMinus})
    print(io, "$(ex.left)")
    print(io, " ⊖ ")
    print(io, "$(ex.right)")
end

##########################
# Parser
##########################

kronparse(expr) = expr

function kronparse(expr::Expr)
    if Meta.isexpr(expr, :ref)
        return KronProd([MatExpr(expr)])
    end

    if !Meta.isexpr(expr, :call)
        return expr
    end

    if expr.args[1] in (:+, :-)
        return make_binary(expr)
    elseif expr.args[1] in (:*, :⋅, :⊗)
        return make_kronprod(expr)
    end
end

function make_binary(expr::Expr)
    if expr.args[1] == :+
        return make_plus(expr)
    else
        return make_minus(expr)
    end
end

isprod(expr) = false
isplus(expr) = false
isminus(expr) = false

isprod(expr::Expr) = expr.args[1] in :(:*, :⋅, :⊗)
isplus(expr::Expr) = expr.args[1] == :+
isminus(expr::Expr) = expr.args[1] == :-

make_plus(expr::Expr) = BinaryExpr(DirectPlus, expr)
make_minus(expr::Expr) = BinaryExpr(DirectMinus, expr)

function BinaryExpr(::Type{OP}, expr::Expr) where OP
    seq = copy(expr.args[2:end])

    if length(seq) == 2
        r = BinaryExpr(
            OP,
            kronparse(seq[1]),
            kronparse(seq[2])
        )
        return r
    else
        return BinaryExpr(
            OP,
            BinaryExpr(
                DirectPlus,
                Expr(:call, :+, seq[1:end-1]...),
            ),
            kronparse(seq[end])
        )
    end
end

import Base: push!, pop!, merge!, merge, copy

copy(c::KronProd) = KronProd(c.len, copy(c.args))
copy(ex::BinaryExpr{OP}) where OP = BinaryExpr(OP, copy(ex.left), copy(ex.right))

push!(c::KronExpr, m::Expr) = push!(c, MatExpr(m))
pop!(c::KronProd) = heappop!(c.args)

function push!(ex::KronProd, m::MatExpr)
    heappush!(ex.args, m)
    if ex.len < m.index
        ex.len = m.index
    end
    return ex
end

function push!(ex::BinaryExpr{OP, LHS, RHS}, m::MatExpr) where {OP, LHS, RHS}
    push!(ex.left, m)
    push!(ex.right, m)
    return ex
end

# lhs = lhs * rhs
function merge!(lhs::KronProd, rhs::KronProd)
    for each in rhs.args
        push!(lhs, each)
    end

    lhs.len = max(lhs.len, rhs.len)
    return lhs
end

merge(lhs::KronProd, rhs::KronProd) = merge!(copy(lhs), rhs)

# lhs := (lhs[1] + lhs[2]) * rhs = lhs[1] * rhs + lhs[2] * rhs
function merge!(lhs::BinaryExpr, rhs::KronProd)
    merge!(lhs.left, rhs)
    merge!(lhs.right, rhs)

    lhs.len = max(lhs.len, rhs.len)
    return lhs
end

# lhs := lhs[3] * (rhs[1] + rhs[2])
#      = lhs[3] * rhs[1] + lhs[3] * rhs[2]
#      = rhs[1] * lhs[3] + rhs[2] * lhs[3]
function merge(lhs::BinaryExpr, rhs::KronProd)
    merge!(copy(lhs), rhs)
end

merge(lhs::KronProd, rhs::BinaryExpr) = merge(rhs, lhs)


#   (lhs[1] OP1 lhs[2]) * (rhs[3] OP2 rhs[4])
# = lhs[1] * rhs[3] OP2 lhs[1] * rhs[4] OP1 lhs[2] * rhs[3] OP2 lhs[2] * rhs[4]
function merge(lhs::BinaryExpr{OP1}, rhs::BinaryExpr{OP2}) where {OP1, OP2}
    r = BinaryExpr(OP2, merge(lhs.left, rhs.left), merge(lhs.left, rhs.right))
    r = BinaryExpr(OP1, r, merge(lhs.right, rhs.left))
    r = BinaryExpr(OP2, r, merge(lhs.right, rhs.right))
    return r
end

function make_kronprod(expr::Expr)
    ex = KronProd()
    for each in expr.args[2:end]
        if Meta.isexpr(each, :ref)
            push!(ex, each)
        else
            ex = merge(ex, kronparse(each))
        end
    end
    return ex
end

function toexpr(ex::KronProd)
    seq = []
    previous = 0; ind = 0
    while !isempty(ex.args)
        each = pop!(ex)
        val, ind = each.expr, each.index
        for i = previous+1:ind-1
            push!(seq, :σ₀)
        end
        previous = ind
        push!(seq, val)
    end

    if ind < ex.len
        for i = ind+1:ex.len
            push!(seq, :σ₀)
        end
    end
    return vec2kron(seq)
end

toexpr(ex::BinaryExpr{DirectPlus}) = :($(toexpr(ex.left)) + $(toexpr(ex.right)))
toexpr(ex::BinaryExpr{DirectMinus}) = :($(toexpr(ex.left)) - $(toexpr(ex.right)))

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


############################
# Region Sum
############################

export kronsum
# TODO: see issue 27
function kronsum(f::Function, itr::LatticeIterator)
    state = start(itr)
    pos, state = next(itr, state)
    ex = f(getid(itr, pos)...)

    while !done(itr, state)
        pos, state = next(itr, state)
        ex = :($(f(getid(itr, pos)...)) + $ex)
    end

    return eval(toexpr(kronparse(ex)))
end

mutable struct ExprKernel
    ex::Expr
    legs::Vector
end

function ExprKernel(ex::Expr)
    kernel = make_kernel_legs!(ExprKernel(ex, []))
    kernel.ex = expr2lambda(ex)
    return kernel
end

function toexpr(kernel::ExprKernel)
    Expr(:->, Expr(:tuple, kernel.legs...), Expr(:block, Expr(:quote, kernel.ex)))
end

make_kernel_legs!(kernel::ExprKernel, ex::Symbol) = kernel
make_kernel_legs!(kernel::ExprKernel) = make_kernel_legs!(kernel, kernel.ex)

function make_kernel_legs!(kernel::ExprKernel, ex::Expr)
    if Meta.isexpr(ex, :call)
        for each in ex.args
            make_kernel_legs!(kernel, each)
        end
    elseif Meta.isexpr(ex, :ref)
        for each in ex.args[2:end]
            if !(each in kernel.legs)
                push!(kernel.legs, each)
            end
        end
    else
        throw(ErrorException("Invalid Expression $(ex)"))
    end
    return kernel
end

function ref2lambda(expr)
    for i = 2:length(expr.args)
        expr.args[i] = Expr(:$, expr.args[i])
    end
    return expr
end

function expr2lambda(expr)
    if isa(expr, Symbol)
        return expr
    end

    if Meta.isexpr(expr, :call)
        for (i, each) in enumerate(expr.args)
            expr.args[i] = expr2lambda(each)
        end
    elseif Meta.isexpr(expr, :ref)
        return ref2lambda(expr)
    else
        throw(ErrorException("Invalid Expression $(expr)"))
    end
    return expr
end

function kron_sum_region(region, expr)
    kernels = []
    if Meta.isexpr(expr, :block)
        for each in expr.args
            if !Meta.isexpr(each, :line)
                push!(kernels, ExprKernel(each)) 
            end
        end
    else
        push!(kernels, ExprKernel(expr))
    end

    kernel = kernels[1]

    kernel_ex = toexpr(kernel)
    ex = :(kronsum($(esc(kernel_ex)), $(esc(region))))
    for kernel in kernels[2:end]
        ex = :(kronsum($(esc(toexpr(kernel))), $(esc(region))) + $ex)
    end
    
    return ex
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

## Note

the index must be integers, if you want to use expression
interpolation. use `@eval` first.

```julia
i=1; j=3
@eval @kron sigmax[\$i] * sigmay[\$j]
```

    @kron region expr

You can also use @kron to calculate matrix through a region, a
region can be all the sites over lattice or a sepcific area on
the lattice. `expr` will be parsed to a generator that generates
local region's expression.

## Example

```julia
chain = Chain(Fixed, 4)
h = @kron bonds(chain, 1) σ₁[i] * σ₁[j]
```

If you use block, it will sum each generated results of kronnecker expression
together on the same region.

```julia
chain = Chain(Fixed, 4)
h = @kron bonds(chain, 1) begin
    σ₁[i] * σ₁[j]
    σ₂[i] * σ₂[j]
    σ₃[i] * σ₃[j]
end
```
"""
macro kron(expr...)
    if length(expr) == 1
        ex = kronparse(expr...)
        return toexpr(ex)
    elseif length(expr) == 2
        return kron_sum_region(expr...)
    end
end

end

using .Kronecker
export kronprod, kronsum, ⊗, @kron
