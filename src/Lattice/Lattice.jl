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

abstract type LatticeIterator{L} end

abstract type SiteIterator{L} <: LatticeIterator{L} end
abstract type BondIterator{L} <: LatticeIterator{L} end

####################
# Lattice Interface
####################

export shape, sites, bonds

"""
    shape(lattice) -> Tuple

get the shape of a lattice
"""
function shape end

import Base: length

"""
    length(lattice) -> Int

get the length (or the product of
size in each dimension) of the lattice
"""
function length end

"""
    sites(lattice)

get the site iterator of the lattice.
"""
function sites end

"""
    bonds(lattice, k)

get the ``k``th bond's iterator of the lattice
"""
function bonds end

# Implementations
include("Chain.jl")
include("Square.jl")
