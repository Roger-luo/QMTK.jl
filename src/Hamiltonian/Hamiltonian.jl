export AbstractHamiltonian, AbstractRegion, Region, Nearest, NextNearest

#################
# Abstract Types
#################

abstract type AbstractHamiltonian end
abstract type AbstractHamiltonianIterator end

abstract type AbstractRegion end
abstract type Region{ID} <: AbstractRegion end

const Nearest = Region{1}
const NextNearest = Region{2}

#################
# Implementations
#################

include("LocalHamiltonian.jl")
include("General.jl")
include("MacroInterface.jl")
