export @ham

__REGION__ = Dict(
    :nearest => Region{1},
    :nextnearest => Region{2},
)

function _region(sym)
    return __REGION__[sym]
end

function localham(region::Symbol, expr)
    return LocalHamiltonian(_region(region), eval(expr))
end

merge_expr(ex1, ex2) = Expr(:call, :+, ex1, ex2)

function merge(expr)
    symbolic = Dict()

    for each in expr.args[2:end]
        region, localexpr = each.args[2:end]
        if region in keys(symbolic)
            symbolic[region.args[1]] = merge_expr(symbolic[region], localexpr)
        else
            symbolic[region.args[1]] = localexpr
        end
    end
    return symbolic
end

macro ham(expr)
    locals = []
    for (r, l) in merge(expr)
        push!(locals, localham(r, l))
    end

    return Hamiltonian(locals...)
end
