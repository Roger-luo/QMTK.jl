export UnKnownRegionError, RegionIterator

struct UnKnownRegionError{R <: AbstractRegion} <: Exception
end

UnKnownRegionError(::Type{R}) where R = UnKnownRegionError{R}()

import Base: showerror

function showerror(io::IO, e::UnKnownRegionError{R}) where R
    print(io, "unknown region $R")
end

mutable struct RegionIterator{
        R <: AbstractRegion,
        B,
        LI<:LatticeIterator
    } <: AbstractHamiltonianIterator

    hamilton::LocalHamiltonian{B, R}
    lattice_it::LI
    RHS::Sites
end

RegionIterator(
    h::LocalHamiltonian{B, Region{0}},
    lattice::AbstractLattice,
    rhs::AbstractSites
) where B = RegionIterator(h, sites(lattice), rhs)

RegionIterator(
    h::LocalHamiltonian{B, Region{K}},
    lattice::AbstractLattice,
    rhs::AbstractSites
) where {B, K} = RegionIterator(h, bonds(lattice, K), rhs)

mutable struct RegionIterState{
        LST, Lv,
        HIT <: AbstractHamiltonianIterator,
        HST
    }
    
    lattice_st::LST # Lattice State
    lattice_va::Lv # Lattice Value
    hamilton_it::HIT # Hamilton Iter
    hamilton_st::HST # Hamilton State
end

function RegionIterState(itr::RegionIterator{Region{0}})
    lattice_st = start(itr.lattice_it)
    i, lattice_st = next(itr.lattice_it, lattice_st)
    hamilton_it = LHIterator(itr.hamilton, itr.RHS[i])
    hamilton_st = start(hamilton_it)
    return RegionIterState(lattice_st, i, hamilton_it, hamilton_st)
end

function RegionIterState(itr::RegionIterator{Region{K}}) where K
    lattice_st = start(itr.lattice_it)
    (i, j), lattice_st = next(itr.lattice_it, lattice_st)
    hamilton_it = LHIterator(itr.hamilton, itr.RHS[i], itr.RHS[j])
    hamilton_st = start(hamilton_it)
    return RegionIterState(lattice_st, (i, j), hamilton_it, hamilton_st)
end

import Base: start, next, done

# eltype(itr::RegionIterator) = Tuple{}
start(itr::RegionIterator) = RegionIterState(itr)

function next(itr::RegionIterator{Region{K}}, state) where K
    (val, (Si, Sj)), state.hamilton_st = next(state.hamilton_it, state.hamilton_st)
    i, j = state.lattice_va
    LHS = copy(itr.RHS)
    LHS[i] = Si; LHS[j] = Sj
    return (val, LHS), state
end

function done(itr::RegionIterator{Region{K}}, state) where K
    if done(state.hamilton_it, state.hamilton_st)
        if done(itr.lattice_it, state.lattice_st)
            return true
        end

        (i, j), state.lattice_st = next(itr.lattice_it, state.lattice_st)
        state.hamilton_it = LHIterator(itr.hamilton, itr.RHS[i], itr.RHS[j])
        state.hamilton_st = start(state.hamilton_it)
        state.lattice_va = (i, j)
    end
    return false
end

function next(itr::RegionIterator{Region{0}}, state)
    (val, Si), state.hamilton_st = next(state.hamilton_it, state.hamilton_st)
    LHS = copy(itr.RHS)
    LHS[i] = Si
    return (val, LHS), state
end

function done(itr::RegionIterator{Region{0}}, state)
    if done(state.hamilton_it, state.hamilton_st)
        if done(itr.lattice_it, state.lattice)
            return true
        end

        i, state.lattice_st = next(itr.lattice_it, state.lattice_st)
        state.hamilton_it = LHIterator(itr.hamilton, itr.RHS[i])
        state.hamilton_st = start(state.hamilton_it)
        state.lattice_va = i
    end
end
