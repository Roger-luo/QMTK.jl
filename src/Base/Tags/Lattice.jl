export Fixed, Periodic
########################
# Abstract Boundaries
########################

"""
    LatticeTag

Abstract type for lattice properties can be
determined in compile time.
"""
abstract type LatticeTag <: AbstractTag end

"""
    Boundary <: LatticeTag

Abstract type for boundary conditions.
"""
abstract type Boundary <: LatticeTag end

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


# Square Bonds Iterator
export Vertical, Horizontal, UpRight, UpLeft

abstract type LatticeIterTag end
abstract type Vertical{N} <: LatticeIterTag end
abstract type Horizontal{N} <: LatticeIterTag end
abstract type UpRight{N} <: LatticeIterTag end
abstract type UpLeft{N} <: LatticeIterTag end


export AbstractRegion, Region
# Regions

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

