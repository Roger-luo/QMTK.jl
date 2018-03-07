export Square

"""
"""
struct Square{B<:Boundary} <: BCLattice{B, 2}
    width::Int
    height::Int
end

Square(width::Integer, height::Integer) = Square{Fixed}(width, height)
Square(::Type{B}, width::Integer, height::Integer) where {B<:Boundary} = 
    Square{B}(width, height)
Square(shape::Tuple{Int, Int}) = Square(Fixed, shape)
Square(::Type{B}, shape::Tuple{Int, Int}) where {B<:Boundary} =
    Square{B}(shape...)

shape(square::Square) = (square.width, square.height)
length(square::Square) = square.width * square.height
sites(square::Square) = SquareSiteIter(square)
bonds(square::Square, bond::Integer) = SquareBondIter(square, bond)

struct SquareSiteIter <: SiteIterator{Square}
    width::Int
    height::Int
end

SquareSiteIter(square::Square) = SquareSiteIter(square.width, square.height)

struct SquareBondIter{B<:Boundary, K} <: BondIterator{Square{B}}
    width::Int
    height::Int
end

abstract type Odd{K} end
abstract type Even{K} end

function SquareBondIter(square::Square{B}, bond::Int) where {B<:Boundary}
    if bond % 2 == 0
        k = Int(bond/2)
        return SquareBondIter{B, Even{k}}(square.width, square.height)
    else
        k = floor(Int, (bond + 1) / 2)
        return SquareBondIter{B, Odd{k}}(square.width, square.height)
    end
end

#####################
# Iterator Interface
#####################

import Base: start, next, done, eltype, length

start(itr::SquareSiteIter) = (1, 1)

function next(itr::SquareSiteIter, state::Tuple{Int, Int})
    i, j = state

    if j > itr.height - 1
        return (i, j), (i+1, 1)
    end

    return (i, j), (i, j+1)
end

done(itr::SquareSiteIter, state::Tuple{Int, Int}) = state[1] > itr.width

length(itr::SquareSiteIter) = itr.width * itr.height
eltype(itr::SquareSiteIter) = Tuple{Int, Int}

start(itr::SquareBondIter) = (1, 1, 1)
eltype(itr::SquareBondIter) = NTuple{2, NTuple{2, Int}}

function done(itr::SquareBondIter, state::NTuple{3, Int})
    i, j, count = state
    return count > length(itr)
end

#################
# Fixed Boundary
#################

function length(itr::SquareBondIter{Fixed, Odd{K}}) where K
    return itr.height * (itr.width - K) + itr.width * (itr.height - K)
end

function next(itr::SquareBondIter{Fixed, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state
    
    if count < (itr.width - K) * itr.height + 1
        return _horizontal(itr, state)
    elseif count == (itr.width - K) * itr.height + 1
        return _vertical(itr, (1, 1, count))
    else
        return _vertical(itr, state)
    end
end

@inline function _vertical(itr::SquareBondIter{Fixed, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if i > itr.width
        return ((1, j+1), (1, j+K+1)), (2, j+1, count+1)
    else
        return ((i, j), (i, j+K)), (i+1, j, count+1)
    end
end

@inline function _horizontal(itr::SquareBondIter{Fixed, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if j > itr.height
        return ((i+1, 1), (i+K+1, 1)), (i+1, 2, count+1)
    else
        return ((i, j), (i + K, j)), (i, j+1, count+1)
    end
end

#######
# Even
#######

function length(itr::SquareBondIter{Fixed, Even{K}}) where K
    return 2 * (itr.width - K) * (itr.height - K)
end

function next(itr::SquareBondIter{Fixed, Even{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if count < (itr.width - K) * (itr.height - K) + 1
        return _upper_right(itr, state)
    elseif count == (itr.width - K) * (itr.height - K) + 1
        return _upper_left(itr, (1, 1, count))
    else
        return _upper_left(itr, state)
    end
end

function _upper_left(itr::SquareBondIter{Fixed, Even{K}}, state::NTuple{3, Int}) where K
    i, j, count = state
    
    if i > itr.width - K
        return ((K+1, j+1), (1, j+K+1)), (2, j+1, count+1)
    end
    return ((i+K, j), (i, j+K)), (i+1, j, count+1)
end

function _upper_right(itr::SquareBondIter{Fixed, Even{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if j > itr.height - K
        return ((i+1, 1), (i+K+1, 1+K)), (i+1, 2, count+1)
    end
    return ((i, j), (i+K, j+K)), (i, j+1, count+1)
end

####################
# Periodic Boundary
####################

length(itr::SquareBondIter{Periodic, K}) where K = 2 * itr.width * itr.height

######
# Odd
######

function next(itr::SquareBondIter{Periodic, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if count < itr.width * itr.height + 1
        return _horizontal(itr, state)
    elseif count == itr.width * itr.height + 1
        return _vertical(itr, (1, 1, count))
    else
        return _vertical(itr, state)
    end
end

function _horizontal(itr::SquareBondIter{Periodic, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if j > itr.height
        return ((i+1, 1), ((i+K)%itr.width+1, 1)), (i+1, 2, count+1)
    else
        return ((i, j), ((i+K-1)%itr.width+1, j)), (i, j+1, count+1)
    end
end

function _vertical(itr::SquareBondIter{Periodic, Odd{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if i > itr.width
        return ((1, j+1), (1, (j+K)%itr.height+1)), (2, j+1, count+1)
    else
        return ((i, j), (i, (j+K-1)%itr.height+1)), (i+1, j, count+1)
    end
end

#######
# Even
#######

function next(itr::SquareBondIter{Periodic, Even{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if count < itr.width * itr.height + 1
        return _upper_right(itr, state)
    elseif count == itr.width * itr.height + 1
        return _upper_left(itr, (1, 1, count))
    else
        return _upper_left(itr, state)
    end
end

function _upper_left(itr::SquareBondIter{Periodic, Even{K}}, state::NTuple{3, Int}) where K
    i, j, count = state
    
    if i > itr.width
        return ((K%itr.width+1, j+1), (1, (j+K)%itr.height+1)), (2, j+1, count+1)
    end
    return (((i+K-1)%itr.width+1, j), (i, (j+K-1)%itr.height+1)), (i+1, j, count+1)
end

function _upper_right(itr::SquareBondIter{Periodic, Even{K}}, state::NTuple{3, Int}) where K
    i, j, count = state

    if j > itr.height
        return ((i+1, 1), ((i+K)%itr.width+1, K%itr.height+1)), (i+1, 2, count+1)
    end
    return ((i, j), ((i+K-1)%itr.width+1, (j+K-1)%itr.height+1)), (i, j+1, count+1)
end
