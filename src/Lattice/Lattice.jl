#################
# Abstract Types
#################

export Periodic, Fixed, AbstractLattice, BCLattice
export isperiodic

"""
    AbstractLattice{N}

Abstract type for lattices. `N` indicated the dimension of
this lattice type.
"""
abstract type AbstractLattice{N} end

########################
# Abstract Boundaries
########################

"""
    LatticeProperty

Abstract type for lattice properties can be
determined in compile time.
"""
abstract type LatticeProperty end

"""
    Boundary <: LatticeProperty

Abstract type for boundary conditions.
"""
abstract type Boundary <: LatticeProperty end

"""
    Periodic <: Boundary

Periodic boundary tag.
"""
abstract type Periodic <: Boundary end

"""
    Fixed <: Boundary

Fixed boundary tag.
"""
abstract type Fixed <: Boundary end

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
