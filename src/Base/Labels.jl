export AbstractTag, LHS, RHS, SpaceState, UnRandomized, Randomized
export SiteLabel, BitSiteLabel, Bit, Spin, Half

abstract type AbstractTag end

##############
# General
##############

abstract type LHS <: AbstractTag end
abstract type RHS <: AbstractTag end

abstract type SpaceState <: AbstractTag end
abstract type UnRandomized <: SpaceState end
abstract type Randomized <: SpaceState end

# Exceptions
export UnRandomizedError
import Base: show

"""
Some operations (like some samplers) only accepts randomized sample space

Throw this error, when the arugment does not meet this condition.
"""
struct UnRandomizedError <: Exception
end

function show(io::IO, e::UnRandomizedError)
    println(io, "Need to randomize first")
end

##############
# Site Label
##############

"""
    SiteLabel

Site Labels, type of each element, like Spin, Bit, etc. 
"""
abstract type SiteLabel <: AbstractTag end

"""
    BitSiteLabel <: SiteLabel

Binary Site, like Spin, Bit, etc.
"""
abstract type BitSiteLabel <: SiteLabel end

#################################################################
# Interfaces
import Base: eltype

"""
    eltype(BitSiteLabel)

get tag datatype.
"""
function eltype(::Type{T}) where {T <: BitSiteLabel} end

"""
    up(BitSiteLabel) -> tag

up tag for this label. e.g. `1` for `Bit`, `0.5` for `Half`.
"""
function up(::Type{T}) where {T <: BitSiteLabel} end

"""
    down(BitSiteLabel) -> tag

down tag for this label. e.g. `0` for `Bit`, `-0.5` for `Half`.
"""
function down(::Type{T}) where {T <: BitSiteLabel} end

##################################################################

"""
    Spin <: BitSiteLabel

Binary State, Spin. Has two state: -1, 1
"""
abstract type Spin <: BitSiteLabel end

eltype(::Type{Spin}) = Float32
up(::Type{Spin}) = convert(eltype(Spin), 1.0f0)
down(::Type{Spin}) = convert(eltype(Spin), -1.0f0)

"""
    Bit <: BitSiteLabel

Binary State, Bit. Has two state: 0, 1
"""
abstract type Bit <: BitSiteLabel end

eltype(::Type{Bit}) = Float32
up(::Type{Bit}) = convert(eltype(Bit), 0.0f0)
down(::Type{Bit}) = convert(eltype(Bit), 1.0f0)

"""
    Half <: BitSiteLabel

Binary State, Half. Has two state: -0.5, 0.5
"""
abstract type Half <: BitSiteLabel end

eltype(::Type{Half}) = Float32
up(::Type{Half}) = convert(eltype(Half), 0.5f0)
down(::Type{Half}) = convert(eltype(Half), -0.5f0)
