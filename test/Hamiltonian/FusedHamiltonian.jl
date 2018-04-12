using QMTK
using QMTK.Consts.Pauli

h = @ham sum(Region{1}, σ₁⊗σ₂) + sum(Region{2}, σ₁⊗σ₂)

chain = Chain(Fixed, 4)

t = kronsum(bonds(chain, 1)) do i, j
    :(σ₁[$i] ⊗ σ₂[$j])
end

t += kronsum(bonds(chain, 2)) do i, j
    :(σ₁[$i] ⊗ σ₂[$j])
end

rhs = rand(Bit, 4)
for (val, lhs) in h(chain, rhs)
    @test t[Int(lhs)+1, Int(rhs)+1] == val
end

# merge factor into local matrix
# @ham 2 * sum(Region{1}, σ₁⊗σ₂) # => sum(Region{1}, 2 * σ₁⊗σ₂)

# mat = σ₁⊗σ₂
# h1 = LocalHamiltonian(Region{1}, mat)
# h2 = LocalHamiltonian(Region{2}, mat)

# FusedHamiltonian(h1, h2)
