export @ham

import IterTools

struct FusedHamiltonian{D<:Tuple} <: AbstractHamiltonian
    data::D
end

FusedHamiltonian(h::LocalHamiltonian...) = FusedHamiltonian(h)
function (h::FusedHamiltonian)(lattice::AbstractLattice, rhs::AbstractSites)
    itrs = []
    for each in h.data
        push!(itrs, RegionIterator(each, lattice, rhs))
    end
    IterTools.chain(itrs...)
end

# TODO: refactor this
function make_hamiltonian(ex::Expr)
    expr = Expr(:call, :FusedHamiltonian)
    if Meta.isexpr(ex, :call)
        if ex.args[1] == :sum # only one region
            ex.args[1] = :LocalHamiltonian
            return ex
        elseif ex.args[1] == :+
            for each in ex.args[2:end]
                if each.args[1] == :sum
                    each.args[1] = :LocalHamiltonian
                    push!(expr.args, each)
                elseif each.args[1] == :*
                    factor = each.args[2]
                    each.args[3].args[1] = :LocalHamiltonian
                    each.args[3].args[end] = Expr(:call, :*, factor, each.args[3].args[end])
                    push!(expr.args, each.args[3])
                else
                    throw(ErrorException("Invalid Expression: $each"))
                end
            end
        elseif ex.args[1] == :-
            # preserve sign for the first one
            each = ex.args[2]
            if each.args[1] == :sum
                each.args[1] = :LocalHamiltonian
                push!(expr.args, each)
            elseif each.args[1] == :*
                factor = each.args[2]
                each.args[3].args[1] = :LocalHamiltonian
                each.args[3].args[end] = Expr(:call, :*, factor, each.args[3].args[end])
                push!(expr.args, each.args[3])
            else
                throw(ErrorException("Invalid Expression: $each"))
            end

            for each in ex.args[3:end]
                if each.args[1] == :sum
                    each.args[1] = :LocalHamiltonian
                    each.args[end] = Expr(:call, :*, -1, each.args[end]) # merge -1 to local matrix
                    push!(expr.args, each)
                elseif each.args[1] == :*
                    factor = each.args[2]
                    each.args[3].args[1] = :LocalHamiltonian
                    each.args[3].args[end] = Expr(:call, :*, -1, factor, each.args[3].args[end])
                    push!(expr.args, each.args[3])
                else
                    throw(ErrorException("Invalid Expression: $each"))
                end
            end
        end
    else
        throw(ErrorException("Invalid Expression: $each"))
    end
    return expr
end

macro ham(expr::Expr)
    make_hamiltonian(expr)
end
