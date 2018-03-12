# Pauli Groups
export Pauli

"""
Pauli Matrix
"""
module Pauli
export sigmax, sigmay, sigmaz, sigmai
using Compat.SparseArrays

const sigmax = sparse([0 1;1 0])
const sigmay = sparse([0 -im;im 0])
const sigmaz = sparse([1 0;0 -1])
const sigmai = sparse([1 0;0 1])

export σ, σ₀, σ₁, σ₂, σ₃

const σ₀ = sigmai
const σ₁ = sigmax
const σ₂ = sigmay
const σ₃ = sigmaz

const σ = [sigmai, sigmax, sigmay, sigmaz]

# Pauli Vec

export PauliVector, S, *, ⋅

"""
    PauliVector

PauliVector ``(\sigma_x, \sigma_y, \sigma_z)``
"""
struct PauliVector
end

const S = PauliVector()

import Base: *
*(A::PauliVector, B::PauliVector) = kron(sigmax, sigmax) + kron(sigmay, sigmay) + kron(sigmaz, sigmaz)
⋅(A::PauliVector, B::PauliVector) = A * B

import Base: getindex

function getindex(pv::PauliVector, index::Integer)
    if index == 1
        return sigmax
    elseif index == 2
        return sigmay
    elseif index == 3
        return sigmaz
    else
        throw(BoundsError(pv, index))
    end
end

end