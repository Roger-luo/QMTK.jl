export AbstractHamiltonian, AbstractRegion, Region, Nearest, NextNearest

#################
# Abstract Types
#################

abstract type AbstractHamiltonian end
abstract type AbstractHamiltonianIterator end

"""
    AbstractRegion

abstract region.
"""
abstract type AbstractRegion end

"""
    Region{ID} <: AbstractRegion

denotes the `ID`th Region.
"""
abstract type Region{ID} <: AbstractRegion end

"""
shorthand for `Region{1}`
"""
const Nearest = Region{1}

"""
shorthand for `Region{2}`
"""
const NextNearest = Region{2}

#################
# Implementations
#################

include("LocalHamiltonian.jl")
include("General.jl")
include("MacroInterface.jl")
