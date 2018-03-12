export AbstractSites, SiteLabel, AbstractBitSite, Spin, Bit, Half

export Sites, SubSites
export up, down, sitetype
export reset!, flip!, randflip!

"""
    AbstractSites{Label, T, N} <: AbstractArray{T, N}

Sites are arrays with certain labels
"""
abstract type AbstractSites{Label, T, N} <: AbstractArray{T, N} end

"""
    SiteLabel

Site Labels, type of each element, like Spin, Bit, etc. 
"""
abstract type SiteLabel end

"""
    AbstractBitSite <: SiteLabel

Binary Site, like Spin, Bit, etc.
"""
abstract type AbstractBitSite <: SiteLabel end

"""
    Spin <: AbstractBitSite

Binary State, Spin. Has two state: -1, 1
"""
abstract type Spin <: AbstractBitSite end

"""
    Bit <: AbstractBitSite

Binary State, Bit. Has two state: 0, 1
"""
abstract type Bit <: AbstractBitSite end

"""
    Half <: AbstractBitSite

Binary State, Half. Has two state: -0.5, 0.5
"""
abstract type Half <: AbstractBitSite end

##### Interfaces

"""
    up(basis)

get up state for binary states
"""
function up end

"""
    down(basis)

get down state for binary states
"""
function down end

"""
    data(basis)

get data of the basis
"""
function data(site::AbstractSites) end

# define element type for each type of site
import Base: eltype

# default element data type
# overwritten this if need tweak
# NOTE: only Int64, Float32, Float64 have native blas support
#       Int8 is actually slower for BLAS operations. 
eltype(x::Type{Bit}) = Int8
eltype(x::Type{Spin}) = Int8
eltype(x::Type{Half}) = Float16

up(x::Type{Bit}) = eltype(x)(1)
down(x::Type{Bit}) = eltype(x)(0)

up(x::Type{Spin}) = eltype(x)(1)
down(x::Type{Spin}) = eltype(x)(-1)

up(x::Type{Half}) = eltype(x)(0.5)
down(x::Type{Half}) = eltype(x)(-0.5)

"""
get sitetype from subtypes of `AbstractSites` 
"""
function sitetype end

include("Sites.jl")
include("SubSites.jl")
