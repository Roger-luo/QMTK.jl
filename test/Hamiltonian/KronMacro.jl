using QMTK
using QMTK.Consts.Pauli
using Compat.Test

chain = Chain(Fixed, 4)
t = kronsum(bonds(chain, 1)) do i, j
    :(σ₁[$i] * σ₁[$j])
end
h = kronprod(σ₁, σ₁, σ₀, σ₀) + kronprod(σ₀, σ₁, σ₁, σ₀) + kronprod(σ₀, σ₀, σ₁, σ₁)

@test t == h

chain = Chain(Periodic, 4)
t = kronsum(sites(chain)) do i
    :(σ₁[$i])
end

h = kronprod(σ₁, σ₀, σ₀, σ₀) + kronprod(σ₀, σ₁, σ₀, σ₀) +
    kronprod(σ₀, σ₀, σ₁, σ₀) + kronprod(σ₀, σ₀, σ₀, σ₁)
@test t == h
