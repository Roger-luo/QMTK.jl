using QMTK
using Base.Test

@testset "Utils" begin

using QMTK.Consts.Pauli

@test kronprod(sigmax, sigmax, sigmai) == kron(kron(sigmax, sigmax), sigmai)
@test sigmax ⊗ sigmay ⊗ sigmaz == kron(kron(sigmax, sigmay), sigmaz)

end
