######################
# General Hamiltonian
######################

export Hamiltonian, HamiltonianIterator, mat

mutable struct Hamiltonian{NRegion, B} <: AbstractHamiltonian
    data::NTuple{NRegion, LocalHamiltonian{B}}
end

Hamiltonian(h::LocalHamiltonian...) = Hamiltonian(h)

mutable struct HamiltonianIterator{NRegion} <: AbstractHamiltonianIterator
    iterators::NTuple{NRegion, RegionIterator}
end

function (h::Hamiltonian{NRegion, B})(lattice::L, sites::Sites) where {NRegion, B, L<:AbstractLattice}
    iterators = Tuple(RegionIterator(lh, lattice, sites) for lh in h.data)
    return Iterators.flatten(iterators)
end

# TODO: parallel outer loop
"""
    mat(h, lattice)

Given a lattice, get matrix form of this Hamiltonian
"""
function mat(h::Hamiltonian{NRegion, B}, lattice::L) where {NRegion, B, L<:AbstractLattice}
    space = SiteSpace(sitetype(B), shape(lattice))
    r = spzeros(1 << length(lattice), 1 << length(lattice))
    for lhs in traverse(space)
        i = convert(Int, lhs) + 1
        for (val, rhs) in h(lattice, lhs)
            j = convert(Int, rhs) + 1
            r[i, j] = val
        end
    end
    return r
end