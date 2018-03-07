# Sites Space
export SiteSpace

mutable struct SiteSpace{NFlips, S} <: AbstractSpace{Sites, S}
    data::Sites
end

SiteSpace(::Type{L}, shape::Tuple; nflips=1) where {L <: SiteLabel} =
    SiteSpace{nflips, Random}(rand(L, shape))
SiteSpace(::Type{L}, shape...; nflips=1) where {L <: SiteLabel} = 
    SiteSpace{nflips, Random}(rand(L, shape))
SiteSpace(::Type{S}, space::SiteSpace{N}) where {N, S} = SiteSpace{N, S}(space.data)

# Properties
data(space::SiteSpace) = space.data

# Basics
function reset!(space::SiteSpace{N, Random}) where N
    reset!(space.data)
    return SiteSpace(Initial, space)
end

copy(space::SiteSpace{N, S}) where {N, S} = SiteSpace(space.data)
acquire(space::SiteSpace) = copy(space.data)

# Random methods
shake!(space::SiteSpace{1, Random}) = randflip!(space.data)

function shake!(space::SiteSpace{N, Random}; MAX_FLIP=1000_000) where N
    tape = Int[]
    for i = 1:MAX_FLIP
        offset = rand(1:length(space.data))
        if offset in tape
            continue
        else
            flip!(space.data, offset)
            push!(tape, offset)
        end

        if length(tape) == N
            break
        end
    end

    return space.data
end

function randomize!(space::SiteSpace{N, Initial}) where N
    rand!(space.data)
    return SiteSpace(Random, space)
end

struct SiteTraverser{L <: SiteLabel, T, N} <: AbstractSpaceTraverser
    data::Sites{L, T, N}
end

SiteTraverser(space::SiteSpace) = SiteTraverser(reset!(space.data))

traverse(space::SiteSpace) = SiteTraverser(space)

import Base: start, next, done, length, eltype

eltype(::Type{SiteTraverser{L, T, N}}) where {L, T, N} = Sites{L, T, N}
length(itr::SiteTraverser) = 1 << length(itr.data)

start(itr::SiteTraverser{L}) where L = 1

function next(itr::SiteTraverser, state)
    r = copy(itr.data)
    itr.data << 1
    return r, state + 1
end

done(itr::SiteTraverser, state) = state > length(itr)
