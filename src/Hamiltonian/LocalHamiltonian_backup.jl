export LocalHamiltonian, RegionIterator

mutable struct LocalHamiltonian{B, R, M<:AbstractSparseMatrix} <: AbstractHamiltonian
    data::M
    nzbase::Vector{B}
end

eltype(h::LocalHamiltonian) = eltype(h.data)

@inline function LocalHamiltonian(::Type{B}, ::Type{R}, mat::M) where {B, R, M<:AbstractSparseMatrix}
    nzbase = [convert(B, i-1) for i in mat.rowval]
    LocalHamiltonian{B, R, M}(mat, nzbase)
end

LocalHamiltonian(::Type{T}, ::Type{R}, mat::AbstractSparseMatrix) where {T <: SiteLabel, R} =
    LocalHamiltonian(SubSites{T, eltype(T), Int(log2(size(mat, 1)))}, R, mat)

LocalHamiltonian(::Type{R}, mat::AbstractSparseMatrix) where {R <: AbstractRegion} =
    LocalHamiltonian(Bit, R, mat)

LocalHamiltonian(::Type{T}, mat::AbstractSparseMatrix) where {T <: SiteLabel} =
    LocalHamiltonian(T, Nearest, mat)

LocalHamiltonian(mat::AbstractSparseMatrix) =
    LocalHamiltonian(Bit, Nearest, mat)

struct LocalIterator{Ti, B}
    hamiltonian::LocalHamiltonian{B}
    index::Ti
end

(lh::LocalHamiltonian{B})(lhs...) where B = lh(B(lhs))
function (lh::LocalHamiltonian)(lhs::SubSites)
    return LocalIterator(lh, convert(Int, lhs) + 1)
end

##################
# Iterators
##################

import Base: start, next, done, eltype, length

start(itr::LocalIterator{Int}) = itr.hamiltonian.data.colptr[itr.index]

next(itr::LocalIterator{Int}, state::Int) =
    (itr.hamiltonian.data.nzval[state],
    itr.hamiltonian.nzbase[state]), state+1

done(itr::LocalIterator{Int}, state::Int) =
    state >= itr.hamiltonian.data.colptr[itr.index+1]

eltype(itr::LocalIterator{Int, B}) where {B} = Tuple{eltype(itr.hamiltonian), B}
length(itr::LocalIterator{Int, B}) where {B} =
    itr.hamiltonian.data.colptr[itr.index+1] - itr.hamiltonian.data.colptr[itr.index]

###################
# Region Iterations
###################

struct UnKnownRegionError{T} <: Exception
end

UnKnownRegionError(::Type{R}) where R = UnKnownRegionError{R}()

mutable struct RegionIterator{B, LI<:LatticeIterator, R <: AbstractRegion} <: AbstractHamiltonianIterator
    hamiltonian::LocalHamiltonian{B, R}
    lattice::LI
    sites::Sites
end

function RegionIterator(h::LocalHamiltonian{B, R}, lattice::AbstractLattice, sites::AbstractSites) where {B <: SubSites, R <: AbstractRegion}
    throw(UnKnownRegionError(R))
end

RegionIterator(
    h::LocalHamiltonian{B, Region{0}},
    lattice::AbstractLattice,
    sites::AbstractSites
    ) where {B <: SubSites} =
        RegionIterator(h, sites(lattice), sites)

RegionIterator(
    h::LocalHamiltonian{B, Region{K}},
    lattice::AbstractLattice,
    sites::AbstractSites
    ) where {B <: SubSites, K} =
        RegionIterator(h, bonds(lattice, K), sites)

# TODO: optimization for Region{0} -> result can actually be inferred directly
# complexity should be reduced.

start(itr::RegionIterator) = (start(itr.lattice), nothing, nothing, nothing, nothing, true)

function next(itr::RegionIterator, state)
    lattice_state, i, j, local_itr, local_state, isdone = state
    if isdone
        (i, j), lattice_state = next(itr.lattice, lattice_state)
        local_itr = itr.hamiltonian(itr.sites[i...], itr.sites[j...])
        local_state = start(local_itr)
        isdone = false
    end

    (val, (Si, Sj)), local_state = next(local_itr, local_state)
    rhs = copy(itr.sites)
    rhs[i...] = Si; rhs[j...] = Sj;
    return (val, rhs), (lattice_state, i, j, local_itr, local_state, done(local_itr, local_state))
end

function done(itr::RegionIterator, state)
    lattice_state, i, j, local_itr, local_state, isdone = state
    return done(itr.lattice, lattice_state) && isdone
end