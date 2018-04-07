using QMTK
using QMTK.Consts.Pauli
using Compat.Test

@testset "local hamiltonian" begin

    mat = σ₁⊗σ₂
    display(mat)
    println()
    h = LocalHamiltonian(mat)
    rhs = SubSites(Bit, 1, 0)
    rhs_idx = Int(rhs) + 1
    itr = LHIterator(h, rhs)

    for (val, lhs) in itr
        lhs_idx = Int(lhs) + 1
        @test val == mat[lhs_idx, rhs_idx]
    end

end # testset
