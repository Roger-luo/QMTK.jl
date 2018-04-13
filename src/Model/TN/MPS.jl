export MPS

struct MPS{T, Tensor <: AbstractArray{T, 3}, N} <: AbstractBlock
    tensors::NTuple{N, Tensor}
end

# check if bonds match
# tensors should be an iterable
function check_bonds(tensors)
    for (prev, curr) in zip(tensors[1:end-1], tensors[2:end])
        size(prev, 3) == size(curr, 1) || return false
    end

    size(tensors[1], 1) == size(tensors[end], 3) || return false
    return true
end

function MPS(tensors::AbstractArray{T, 3}...) where T
    # TODO: custom exception
    check_bonds(tensors) || throw(ErrorException("MPS bonds mismatch"))
    MPS{T, eltype(tensors), length(tensors)}(tensors)
end

function MPS(::Type{T}, bonds::NTuple{M, I}, physicals::NTuple{N, I}) where {T, M, N, I <: Integer}
    @assert M == N + 1 "Physical legs and number of tensors mismatch"

    tensors = ntuple(i->rand(T, bonds[i], physicals[i], bonds[i+1]), N)
    MPS{T, Array{T, 3}, N}(tensors)
end

MPS(bonds::NTuple{M, I}, physicals::NTuple{N, I}) where {M, I, N} =
    MPS(Float64, bonds, physicals)
MPS(::Type{T}, bonds::NTuple{N, I}) where {T, N, I <: Integer} = MPS(T, bonds, ntuple(x->2, N-1))
MPS(::Type{T}, bonds::Integer...) where T = MPS(T, bonds)
MPS(bonds::Integer...) = MPS(Float64, bonds)

# MPS should be iteratable

import Base: length, eltype, start, next, done, getindex

length(mps::MPS{T, Tensor, N}) where {T, Tensor, N} = N
eltype(mps::MPS{T, Tensor, N}) where {T, Tensor, N} = Tensor
start(mps::MPS) = start(mps.tensors)
next(mps::MPS, state) = next(mps.tensors, state)
done(mps::MPS, state) = next(mps.tensor, state)
getindex(mps::MPS, index::Integer) = getindex(mps.tensor, index)

export virtual_bonds, physical_bonds, virtual_bond, physical_bond

virtual_bonds(mps::MPS) = push!([size(each, 1) for each in mps.tensors], size(mps.tensors[end], 3))

function virtual_bond(mps::MPS{T, TT, N}, index::Integer) where {T, TT, N}
    index == N+1 && return size(mps.tensors[end], 3)
    return size(mps.tensors[index], 1)
end

physical_bonds(mps::MPS) = [size(each, 2) for each in mps.tensors]
physical_bond(mps::MPS, index::Integer) = size(mps.tensors[index], 2)

import Base: show

"""
MPS{Float64, Array{Float64, 3}, 10}:
2 -[2]- 10 -[2]- 10 -[2]- 2
"""
function show_mps(io::IO, mps::MPS{T, TT, N}) where {T, TT, N}
    mps_str = ""
    physicals = physical_bonds(mps)
    virtuals = virtual_bonds(mps)
    for i = 1:N
        mps_str *= string(virtuals[i]) * " -[$(physicals[i])]- "
    end
    mps_str *= " $(virtuals[end])"
    print(io, mps_str)
end

@static if VERSION < v"0.7-"

function show(io::IO, ::MIME"text/plain", mps::MPS{T, TT, N}) where {T, TT, N}
    print(io, summary(mps))
    println(io, ":")
    show_mps(io, mps)
end

else # for v0.7+

function show(io::IO, ::MIME"text/plain", mps::MPS{T, TT, N}) where {T, TT, N}
    summary(io, mps)
    println(io, ":")
    show_mps(io, mps)
end

end

import Compat: LinearAlgebra

# TODO: cache the contraction
function forward(mps::MPS, input::AbstractVector)    
    itr = zip(mps.tensors[1:end-1], mps.tensors[2:end],
                input[1:end-1], input[2:end])
    for (prev, curr, prev_i, curr_i) in itr
        LinearAlgebra.BLAS.gemm('N', 'N', prev[:, prev_i, :], curr[:, curr_i, :])
    end
    return itr
end
