using QMTK
using QMTK.Consts.Pauli
using Compat.Test

@testset "local hamiltonian" begin

mat = σ₁⊗σ₂
h = LocalHamiltonian(mat)
itr = LHIterator(h, 1, 0)

for (val, index) in itr
    @test val == im
    @test convert(Int, index) + 1 == 2
end

end # testset
