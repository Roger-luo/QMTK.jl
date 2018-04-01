export AbstractHamiltonian, AbstractHamiltonianIterator

abstract type AbstractHamiltonian end
abstract type AbstractHamiltonianIterator end

export LocalHamiltonian, LHIterator

mutable struct LocalHamiltonian{B, R, M<:AbstractSparseMatrix}
    data::M
    nzbase::Vector{B}
end

function LocalHamiltonian(::Type{B}, ::Type{R}, mat::M) where {B, R, M}
    nzbase = [convert(B, i-1) for i in mat.rowval]
    LocalHamiltonian{B, R, M}(mat, nzbase)
end

LocalHamiltonian(::Type{T}, ::Type{R}, mat::AbstractSparseMatrix) where {T <: SiteLabel, R} =
    LocalHamiltonian(SubSites{T, eltype(T), Int(log2(size(mat, 1)))}, R, mat)
LocalHamiltonian(::Type{R}, mat::AbstractSparseMatrix) where {R <: AbstractRegion} =
    LocalHamiltonian(Bit, R, mat)
LocalHamiltonian(::Type{T}, mat::AbstractSparseMatrix) where {T <: SiteLabel} =
    LocalHamiltonian(Bit, Region{1}, mat)
LocalHamiltonian(mat::AbstractSparseMatrix) =
    LocalHamiltonian(Bit, Region{1}, mat)

# LocalHamiltonian shares some similar interface
# with SparseMatrix, for convinience.
# But it is not a subtype of AbstractArray
import Base: eltype, length, ndims, size, eachindex, stride, getindex
import Compat: axes
eltype(h::LocalHamiltonian) = eltype(h.data)
length(h::LocalHamiltonian) = length(h.data)
ndims(h::LocalHamiltonian) = ndims(h.data)
size(h::LocalHamiltonian) = size(h.data)
size(h::LocalHamiltonian, n::Integer) = size(h.data, n)
axes(h::LocalHamiltonian) = axes(h.data)
axes(h::LocalHamiltonian, d::Integer) = axes(h.data)
eachindex(h::LocalHamiltonian) = eachindex(h.data)
stride(h::LocalHamiltonian, k::Integer) = stride(h.data, k)
strides(x::LocalHamiltonian) = strides(x.data)

# TODO: support indexing with Sites
getindex(x::LocalHamiltonian, index::Integer...) = getindex(x.data, index...)
setindex!(x::LocalHamiltonian, val, index::Integer...) = setindex!(x.data, val, index...)

import Base: show

function show(io::IO, h::LocalHamiltonian{B, R, M}) where {B, R, M}
    print(io, "LocalHamiltonian{$B, $R, $M}")
    print(io, h.data)
end

mutable struct LHIterator{B, R, M} <: AbstractHamiltonianIterator
    data::M
    nzbase::Vector{B}
    index::Int
end

LHIterator(::Type{R}, data::M, nzbase::Vector{B}, index::Int) where {R, M, B} =
    LHIterator{B, R, M}(data, nzbase, index)

LHIterator(h::LocalHamiltonian{B, R, M}, rhs::SubSites) where {B, R, M} =
    LHIterator(R, h.data, h.nzbase, convert(Int, rhs) + 1)
LHIterator(h::LocalHamiltonian{B}, rhs::Number...) where B =
    LHIterator(h, B(rhs))

import Base: start, next, done, eltype, length

start(itr::LHIterator) = itr.data.colptr[itr.index]
next(itr::LHIterator, state) = (itr.data.nzval[state], itr.nzbase[state]), state+1
done(itr::LHIterator, state) = state >= itr.data.colptr[itr.index+1]

eltype(itr::LHIterator{Ti, B}) where {Ti, B} = Tuple{eltype(itr.data), B}
length(itr::LHIterator{Ti, B}) where {Ti, B} =
    itr.data.colptr[itr.index] - itr.data.colptr[itr.index]
