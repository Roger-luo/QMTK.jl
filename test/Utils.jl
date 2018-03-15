using QMTK
using Compat.Test

@testset "Utils" begin

using QMTK.Consts.Pauli

@test kronprod(sigmax, sigmax, sigmai) == kron(kron(sigmax, sigmax), sigmai)
@test sigmax ⊗ sigmay ⊗ sigmaz == kron(kron(sigmax, sigmay), sigmaz)

h = @kron sigmax[1] ⊗ sigmaz[3] + sigmax[2] ⊗ sigmay[4]
ans = kronprod(σ₁, σ₀, σ₃, σ₀) + kronprod(σ₀, σ₁, σ₀, σ₂)
@test h == ans

end
