using QMTK
using Base.Test
using QMTK.Consts.Pauli

@testset "Hamiltonian Parser" begin

lh1 = LocalHamiltonian(Region{1}, kron(sigmax, sigmax))
lh2 = LocalHamiltonian(Region{2}, kron(sigmax, sigmax))
chain = Chain{Fixed}(4)
sites = rand(Bit, 4)

h = Hamiltonian(lh1, lh2)
m = mat(h, chain)
precise = kronprod(sigmax, sigmax, sigmai, sigmai) + kronprod(sigmai, sigmax, sigmax, sigmai) +
    kronprod(sigmai, sigmai, sigmax, sigmax) + kronprod(sigmax, sigmai, sigmax, sigmai) +
    kronprod(sigmai, sigmax, sigmai, sigmax)

@test m == precise

end
