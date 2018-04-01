export Square

"""
    Square{B} <: BCLattice{B, 2}

General square lattice with boundary condition `B`.

    Square([Boundary], height, width)
    Square([Boundary], shape)

Construct a square lattice. The shape follows the order of Julia's
Native Array.
"""
struct Square{B <: Boundary} <: BCLattice{B, 2}
    height::Int
    width::Int
end

Square(height::Integer, width::Integer) = Square{Fixed}(height, width)
Square(::Type{B}, height::Integer, width::Integer) where {B <: Boundary} =
    Square{B}(height, width)
Square(shape::Tuple{Int, Int}) = Square(Fixed, shape)
Square(::Type{B}, shape::Tuple{Int, Int}) where {B <: Boundary} =
    Square{B}(shape...)

shape(square::Square) = (square.height, square.width)
length(square::Square) = square.height * square.width
sites(square::Square) = SquareSiteIter(square)

struct SquareSiteIter{B<:Boundary} <: SiteIterator{Square{B}}
    height::Int
    width::Int
end

SquareSiteIter(square::Square{B}) where B = SquareSiteIter{B}(square.height, square.width)

struct SquareBondIter{B<:Boundary, K} <: BondIterator{Square{B}}
    height::Int
    width::Int
end

SquareBondIter(square::Square{B}, ::Type{K}) where {B, K} =
    SquareBondIter{B, K}(square.height, square.width)

lattice(itr::LatticeIterator{Square{B}}) where B =
    Square(B, itr.height, itr.width)

# TODO: add bounds check, throw LoadError when bond is invalid

function bonds(square::Square, bond::Integer)
    if bond % 2 == 1
        k = Int((bond + 1) / 2)
        return fuse(
            SquareBondIter(square, Vertical{k}),
            SquareBondIter(square, Horizontal{k})
        )
    else
        k = Int(bond / 2)
        return fuse(
            SquareBondIter(square, UpRight{k}),
            SquareBondIter(square, UpLeft{k})
        )
    end
end
#####################
# Iterator Interface
#####################

import Base: start, next, done, eltype, length, size, iteratorsize, HasShape

start(itr::SquareSiteIter) = (1, 1, 1)

function next(itr::SquareSiteIter, state)
    i, j, count = state

    if i > itr.height
        return (1, j+1), (2, j+1, count+1)
    end
    return (i, j), (i+1, j, count+1)
end

done(itr::SquareSiteIter, state) = state[3] > length(itr)

length(itr::SquareSiteIter) = itr.width * itr.height
size(itr::SquareSiteIter) = (itr.height, itr.width)
eltype(itr::SquareSiteIter) = Tuple{Int, Int}
iteratorsize(itr::SquareSiteIter) = HasShape()

######################
# Bonds
######################


start(itr::SquareBondIter) = (1, 1, 1)
eltype(itr::SquareBondIter) = NTuple{2, NTuple{2, Int}}
iteratorsize(itr::SquareBondIter) = HasShape()

function done(itr::SquareBondIter, state::NTuple{3, Int})
    i, j, count = state
    return count > length(itr)
end

##################
# Fixed Boundary
##################

length(itr::SquareBondIter{Fixed, Vertical{K}}) where K =
    (itr.height - K) * itr.width
length(itr::SquareBondIter{Fixed, Horizontal{K}}) where K =
    (itr.width - K) * itr.height
length(itr::SquareBondIter{Fixed, UpRight{K}}) where K =    
    (itr.width - K) * (itr.height - K)
length(itr::SquareBondIter{Fixed, UpLeft{K}}) where K =
    (itr.width - K) * (itr.height - K)

size(itr::SquareBondIter{Fixed, Vertical{K}}) where K = (itr.height - K, itr.width)
size(itr::SquareBondIter{Fixed, Horizontal{K}}) where K = (itr.height, itr.width - K)
size(itr::SquareBondIter{Fixed, UpRight{K}}) where K = (itr.height - K, itr.width - K)
size(itr::SquareBondIter{Fixed, UpLeft{K}}) where K = (itr.height - K, itr.width - K)

function next(itr::SquareBondIter{Fixed, Vertical{K}}, state) where K
    i, j, count = state
    if i + K > itr.height
        return ((1, j+1), (1+K, j+1)), (2, j+1, count+1)
    end

    return ((i, j), (i+K, j)), (i+1, j, count+1)
end

function next(itr::SquareBondIter{Fixed, Horizontal{K}}, state) where K
    i, j, count = state
    if i > itr.height
        return ((1, j+1), (1, j+K+1)), (2, j+1, count+1)
    end
    return ((i, j), (i, j+K)), (i+1, j, count+1)
end

function next(itr::SquareBondIter{Fixed, UpRight{K}}, state) where K
    i, j, count = state
    if i+K > itr.height
        return ((1, j+1), (1+K, j+K+1)), (2, j+1, count+1)
    end
    return ((i, j), (i+K, j+K)), (i+1, j, count+1)
end

function next(itr::SquareBondIter{Fixed, UpLeft{K}}, state) where K
    i, j, count = state
    if i+K > itr.height
        return ((1+K, j+1), (1, j+K+1)), (2, j+1, count+1)
    end
    return ((i+K, j), (i, j+K)), (i+1, j, count+1)
end

####################
# Periodic Boundary
####################

length(itr::SquareBondIter{Periodic}) = itr.height * itr.width
size(itr::SquareBondIter{Periodic}) = (itr.height, itr.width)

function next(itr::SquareBondIter{Periodic, Vertical{K}}, state) where K
    i, j, count = state
    if i > itr.height
        return ((1, j+1), (K%itr.height+1, j+1)), (2, j+1, count+1)
    end

    return ((i, j), ((i+K-1)%itr.height+1, j)), (i+1, j, count+1)
end

function next(itr::SquareBondIter{Periodic, Horizontal{K}}, state) where K
    i, j, count = state
    if i > itr.height
        return ((1, j+1), (1, (j+K)%itr.width+1)), (2, j+1, count+1)
    end
    return ((i, j), (i, (j+K-1)%itr.width+1)), (i+1, j, count+1)
end

function next(itr::SquareBondIter{Periodic, UpRight{K}}, state) where K
    i, j, count = state
    if i > itr.height
        return ((1, j+1), (K%itr.height+1, (j+K)%itr.width+1)), (2, j+1, count+1)
    end
    return ((i, j), ((i+K-1)%itr.height+1, (j+K-1)%itr.width+1)), (i+1, j, count+1)
end

function next(itr::SquareBondIter{Periodic, UpLeft{K}}, state) where K
    i, j, count = state
    if i > itr.height
        return ((K%itr.height+1, j+1), (1, (j+K)%itr.width+1)), (2, j+1, count+1)
    end
    return (((i+K-1)%itr.height+1, j), (i, (j+K-1)%itr.width+1)), (i+1, j, count+1)
end

getid(square::Square, x::Int, y::Int) = x + (y - 1) * square.height
