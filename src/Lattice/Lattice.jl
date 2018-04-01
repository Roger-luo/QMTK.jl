#################
# Abstract Types
#################

export AbstractLattice, BCLattice
export isperiodic

"""
    AbstractLattice{N}

Abstract type for lattices. `N` indicated the dimension of
this lattice type.
"""
abstract type AbstractLattice{N} end


"""
    BCLattice{B, N} <: AbstractLattice{N}

Lattice with boundary condition.
"""
abstract type BCLattice{B, N} <: AbstractLattice{N} end

"""
    isperiodic(lattice) -> Bool

whether this lattice has periodic boundary.
"""
function isperiodic end

isperiodic(ltc::BCLattice{Periodic}) = true
isperiodic(ltc::BCLattice{Fixed}) = false

export LatticeIterator, SiteIterator, BondIterator
export lattice
abstract type LatticeIterator{L} end

"""
    lattice(itr)

get the lattice of `itr`.
"""
function lattice(itr::LatticeIterator) end

abstract type SiteIterator{L} <: LatticeIterator{L} end
abstract type BondIterator{L} <: LatticeIterator{L} end

####################
# Lattice Interface
####################

export shape, sites, bonds, getid

"""
    shape(lattice) -> Tuple

get the shape of a lattice
"""
function shape(lattice::AbstractLattice) end

import Base: length

"""
    length(lattice) -> Int

get the length (or the product of
size in each dimension) of the lattice
"""
function length(lattice::AbstractLattice) end

"""
    sites(lattice)

get the site iterator of the lattice.
"""
function sites(lattice::AbstractLattice) end

"""
    bonds(lattice, k)

get the ``k``th bond's iterator of the lattice
"""
function bonds(lattice::AbstractLattice) end

"""
    getid(lattice, pos)

get the given position's id on the lattice. QMTK follows
column major order for square lattice.
"""
function getid(lattice::AbstractLattice, pos) end

getid(lattice::AbstractLattice, pos::Tuple) = getid(lattice, pos...)
getid(lattice::AbstractLattice, xpos, ypos) =
    getid(lattice, xpos), getid(lattice, ypos)

getid(itr::LatticeIterator, args...) = getid(lattice(itr), args...)

################
# Fused Region
################
import IterTools    
export Fusion, fuse

"""
    Fusion{T<:Tuple, L <: AbstractLattice} <: LatticeIterator

Fused Latice Iterator, like `IterTools.Chain`, but is
subtype of LatticeIterator and it only takes iterators
from the same lattice type.
"""
struct Fusion{T<:Tuple, L <: AbstractLattice} <: LatticeIterator{L}
    xss::T
end

fuse(xss::LatticeIterator{L}...) where L = Fusion{typeof(xss), L}(xss)
lattice(itr::Fusion) = lattice(first(itr.xss))

import Base: length, eltype, start, next, done

length(itr::Fusion{Tuple{}}) = 0
length(itr::Fusion) = sum(length, itr.xss)
eltype(::Type{Fusion{T}}) where T = IterTools.mapreduce_tt(eltype, typejoin, Union{}, T)

function start(itr::Fusion)
    i = 1
    xs_state = nothing
    while i <= length(itr.xss)
        xs_state = start(itr.xss[i])
        if !done(itr.xss[i], xs_state)
            break
        end
        i += 1
    end
    return i, xs_state
end

function next(itr::Fusion, state)
    i, xs_state = state
    v, xs_state = next(itr.xss[i], xs_state)
    while done(itr.xss[i], xs_state)
        i += 1
        if i > length(itr.xss)
            break
        end
        xs_state = start(itr.xss[i])
    end
    return v, (i, xs_state)
end

done(itr::Fusion, state) = state[1] > length(itr.xss)

# Implementations
include("Chain.jl")
include("Square.jl")
