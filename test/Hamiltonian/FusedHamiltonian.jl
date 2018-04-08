using QMTK
using QMTK.Consts.Pauli

h = @ham sum(Region{1}, σ₁⊗σ₂) + sum(Region{2}, σ₁⊗σ₂)

chain = Chain(Fixed, 4)
rhs = rand(Bit, 4)
for (val, lhs) in h(chain, rhs)
    @show val
    @show lhs
end

# merge factor into local matrix
@ham 2 * sum(Region{1}, σ₁⊗σ₂) # => sum(Region{1}, 2 * σ₁⊗σ₂)

# mat = σ₁⊗σ₂
# h1 = LocalHamiltonian(Region{1}, mat)
# h2 = LocalHamiltonian(Region{2}, mat)

# FusedHamiltonian(h1, h2)
