using QMTK
using QMTK.Consts.Pauli
using Compat.Test

# @testset "local hamiltonian" begin

# mat = σ₁⊗σ₂
# h = LocalHamiltonian(mat)
# itr = LHIterator(h, 1, 0)

# for (val, index) in itr
#     @test val == im
#     @test convert(Int, index) + 1 == 2
# end

# end # testset

chain = Chain(Fixed, 4)
t = kronsum(bonds(chain, 1)) do i, j
    :(σ₁[$i] ⊗ σ₂[$j])
end

rhs = Sites(Bit, [1, 1, 0, 1])
display(t[:, convert(Int, rhs) + 1])

convert(SubSites{Bit, Int, 4}, 2)

println()
h = LocalHamiltonian(Region{1}, σ₁ ⊗ σ₂)
itr = RegionIterator(h, chain, rhs)

# state = start(itr)
# (val, (Si, Sj)), state.hamilton_st = next(state.hamilton_it, state.hamilton_st)

# val, state = next(itr, state)
# done(itr, state)

for (val, lhs) in RegionIterator(h, chain, rhs)
    println(lhs)
    lhs = convert(Int, lhs) + 1
    @show val, lhs
end
