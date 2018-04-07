import QMTK: toexpr, kronparse, getid, Chain, Fixed, bonds, kronsum
using QMTK.Consts.Pauli

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

macro kron(region, expr)
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
    ex = :(kronsum($(esc(kernel_ex)), $region))
    for kernel in kernels[2:end]
        ex = :(kronsum($(esc(toexpr(kernel))), $region) + $ex)
    end
    
    return ex
end


# kernel = ExprKernel(:(σ₁[i] * σ₁[j]))
# f = eval(toexpr(kernel))
# println(f(1, 2))
chain = Chain(Fixed, 4)
# f = @kron bonds(chain, 1) 
# println(f(1, 2))
h = @kron bonds(chain, 1) σ₁[i] * σ₁[j]

# t = kronsum(bonds(chain, 1)) do i, j
#     :(σ₁[$i] * σ₁[$j])
# end

println(h == t)
# println(@macroexpand @kron bonds(chain, 1) σ₁[i] * σ₁[j])

# kernel = ExprKernel(:(a[i] * (b[j] + c[k])))

# println(kernel.legs)
# ex = toexpr(kernel)
# f = eval(ex)
# println(f(1, 2, 3))
# println(kernel.ex)
# println(kernel.legs)

# i, j, k = 2, 3, 4
# # ex = expr2lambda(:(a[i] * (b[j] + c[k])))
# # expr2kernel(ex)

# ex = eval(Expr(:quote, kernel.ex))
# println(ex)

# # @kron sum(bonds(chain, 1)) a[i] * b[j]

# # @kron sum(bonds(chain, 1)) begin
# #     a[i] * b[j]
# #     a[i] * b[j]
# # end
