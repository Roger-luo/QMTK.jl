#################
# Abstract Types
#################

export Periodic, Fixed, AbstractLattice, BCLattice
export isperiodic

abstract type AbstractLattice{N} end

########################
# Abstract Boundaries
########################

abstract type LatticeProperty end
abstract type Boundary <: LatticeProperty end
abstract type Periodic <: Boundary end
abstract type Fixed <: Boundary end
abstract type BCLattice{B, N} <: AbstractLattice{N} end

"""
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
"""
function shape end

import Base: length

"""
"""
function length end

"""
"""
function sites end

"""
"""
function bonds end

# Implementations
include("Chain.jl")
include("Square.jl")
