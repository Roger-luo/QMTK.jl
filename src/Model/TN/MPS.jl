export AbstractTensorTrain, TensorTrain, MPS

abstract type AbstractTensorTrain <: AbstractBlock end

struct TensorTrain{T, Tensor <: AbstractArray{T}} <: AbstractBlock
    tensors::Vector{Tensor}
end

function TensorTrain(tensors::AbstractArray{T}...) where T
    TensorTrain([tensors...])
end

struct MPS{T, Tensor <: AbstractArray{T, 3}, N} <: AbstractBlock
    tensors::NTuple{N, Tensor}
end

function MPS(::Type{T}, bonds::NTuple{M, I}, physicals::NTuple{N, I}) where {T, M, N, I <: Integer}
    @assert M == N + 1 "Physical legs and number of tensors mismatch"

    tensors = ntuple(i->rand(T, bonds[i], physicals[i], bonds[i+1]), N)
    MPS{T, Array{T, 3}, N}(tensors)
end

import Base: show
