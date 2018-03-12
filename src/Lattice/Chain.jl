export Chain

"""
    Chain{B} <: BCLattice{B, 1}

general chain lattice with boundary condition `B`.

    Chain([Boundary], length)

Construct a chain lattice with boundary (optional,
default to be `Fixed`)

```julia-repl
julia> Chain(10)
QMTK.Chain{QMTK.Fixed}(10)

```
"""
struct Chain{B<:Boundary} <: BCLattice{B, 1}
    length::Int
end

Chain(length::Integer) = Chain{Fixed}(length)
Chain(::Type{B}, length::Integer) where {B<:Boundary} = Chain{B}(length)

shape(chain::Chain) = (chain.length, )
length(chain::Chain) = chain.length
sites(chain::Chain) = ChainSiteIter(chain)
bonds(chain::Chain, bond::Int) = ChainBondIter(chain, bond)

struct ChainSiteIter <: SiteIterator{Chain}
    length::Int
end

ChainSiteIter(chain::Chain) = ChainSiteIter(chain.length)

struct ChainBondIter{B<:Boundary, K} <: BondIterator{Chain{B}}
    length::Int
end

ChainBondIter(chain::Chain{B}, bond::Int) where {B<:Boundary} =
    ChainBondIter{B, bond}(chain.length)


############
# Iterators
############

# import iterator interface
import Base: start, next, done, length, eltype

start(itr::ChainSiteIter) = 1
next(itr::ChainSiteIter, state::Int) = (state, state+1)
done(itr::ChainSiteIter, state::Int) = state > itr.length
length(itr::ChainSiteIter) = itr.length
eltype(itr::ChainSiteIter) = Int

# Bond Iterators
eltype(itr::ChainBondIter) = Tuple{Int, Int}
start(itr::ChainBondIter) = 1

next(itr::ChainBondIter{Fixed, K}, state::Int) where K = ((state, state + K), state+1)
done(itr::ChainBondIter{Fixed, K}, state::Int) where K = state > (itr.length - K)
length(itr::ChainBondIter{Fixed, K}) where K = itr.length - K

next(itr::ChainBondIter{Periodic, K}, state::Int) where K = ((state, rem(state+K, itr.length, RoundDown)), state+1)
done(itr::ChainBondIter{Periodic, K}, state::Int) where K = state > itr.length
length(itr::ChainBondIter{Periodic, K}) where K = itr.length
