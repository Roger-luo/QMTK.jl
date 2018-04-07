export SiteLabel, BitSiteLabel, Bit, Spin, Half
export up, down

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
import Base: eltype, is

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

"""
    is(x, BitSiteLabel) -> Bool

check if x is of given BitSiteLabel
"""
is(::Type{T}, x::Number) where {T <: BitSiteLabel} =
    x == up(T) ? true : x == down(T) ? true : false
is(::Type{T}, x::NTuple{N, D}) where {T <: BitSiteLabel, D <: Number, N} =
    all(is(T, each) for each in x)

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
up(::Type{Bit}) = convert(eltype(Bit), 1.0f0)
down(::Type{Bit}) = convert(eltype(Bit), 0.0f0)

"""
    Half <: BitSiteLabel

Binary State, Half. Has two state: -0.5, 0.5
"""
abstract type Half <: BitSiteLabel end

eltype(::Type{Half}) = Float32
up(::Type{Half}) = convert(eltype(Half), 0.5f0)
down(::Type{Half}) = convert(eltype(Half), -0.5f0)
