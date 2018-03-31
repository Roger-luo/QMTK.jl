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
bonds(square::Square, bond::Integer) = SquareBondIter(square, bond)

struct SquareSiteIter <: SiteIterator{Square}
    height::Int
    width::Int
end

SquareSiteIter(square::Square) = SquareSiteIter(square.height, square.width)

struct SquareBondIter{B<:Boundary, K} <: BondIterator{Square{B}}
    height::Int
    width::Int
end

SquareBondIter(square::Square{B}, ::Type{K}) where {B, K} =
    SquareBondIter{B, K}(square.height, square.width)

abstract type Odd{K} end
abstract type Even{K} end

function SquareBondIter(square::Square{B}, bond::Int) where B
    if bond % 2 == 0
        k = Int(bond / 2)
        return SquareBondIter(square, Even{k})
    else
        k = floor(Int, (bond + 1) / 2)
        return SquareBondIter(square, Odd{k})
    end
end

#####################
# Iterator Interface
#####################

import Base: start, next, done, eltype, length

start(itr::SquareSiteIter) = (1, 1)

function next(itr::SquareSiteIter, state::Tuple{Int, Int})
    i, j = state

    if i > itr.height - 1
        return (i, j), (1, j+1)
    end
    return (i, j), (i+1, j)
end

done(itr::SquareSiteIter, state::Tuple{Int, Int}) = state[2] > itr.width

length(itr::SquareSiteIter) = itr.width * itr.height
eltype(itr::SquareSiteIter) = Tuple{Int, Int}

######################
# Bonds
######################


start(itr::SquareBondIter) = (1, 1, 1)
eltype(itr::SquareBondIter) = NTuple{2, NTuple{2, Int}}

function done(itr::SquareBondIter, state::NTuple{3, Int})
    i, j, count = state
    return count > length(itr)
end

##################
# Fixed Boundary
##################

function length(itr::SquareBondIter{Fixed, Odd{K}}) where K
    (itr.height - K) * itr.width + itr.height * (itr.width - K)    
end

function next(itr::SquareBondIter{Fixed, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if count < (itr.height - K) * itr.width + 1
        return next_vertical(itr, state)
    elseif count == (itr.height - K) * itr.width + 1
        return next_horizontal(itr, (1, 1, count))
    else
        return next_horizontal(itr, state)
    end
end

@inline function next_horizontal(itr::SquareBondIter{Fixed, Odd{K}}, state::NTuple{3, Int}) where K    
    i, j, count = state

    if j + K > itr.width
        return ((i+1, 1), (i+1, 1+K)), (i+1, 2, count+1)
    end

    return ((i, j), (i, j+K)), (i, j+1, count+1)
end

@inline function next_vertical(itr::SquareBondIter{Fixed, Odd{K}}, state::NTuple{3, Int}) where K    
    i, j, count = state

    if i + K > itr.height
        return ((1, j+1), (1+K, j+1)), (2, j+1, count+1)
    end

    return ((i, j), (i+K, j)), (i+1, j, count+1)
end


