using QMTK
using QMTK.Consts.Pauli

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

h = @ham sum(:nearest, S * S) + sum(:nextnearest, S * S) + sum(:nearest, kron(sigmax, sigmax))

println(h)
# Random = @ham sum(:rand, J(i,j) * S(i) * S(j))


# J1J2
# Chain: length 8, Fixed Boundary
chain = Chain{Fixed}(4)

itr = bonds(chain, 1)
state = start(itr)
(i, j), state = next(itr, state)
local_expr(i, j) = :(σ₁[$i] * σ₁[$j] + σ₂[$i] * σ₂[$j] + σ₃[$i]*σ₃[$j])
# local_expr(i, j) = :(σ₁[$i] * σ₁[$j])
@show i, j
ex = local_expr(i, j)

while !done(itr, state)
    (i, j), state = next(itr, state)
    @show i, j
    ex = :($(local_expr(i, j)) + $ex)
end

println(ex)
# println(eval(toexpr(kronparse(ex))))
# println(QMTK._kron(ex))


h = @ham sum(:nearest, S * S) + sum(:nextnearest, S * S)

# lh1 = LocalHamiltonian(Region{1}, kron(sigmax, sigmax))
# lh2 = LocalHamiltonian(Region{2}, kron(sigmax, sigmax))
chain = Chain{Fixed}(4)
lhs = rand(Bit, 4)

# h = Hamiltonian(lh1, lh2)

for (val, rhs) in h(chain, lhs)
    i = convert(Int, lhs) + 1
    println(val, ", ", rhs)
end
