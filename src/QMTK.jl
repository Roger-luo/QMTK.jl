__precompile__()

module QMTK

# NOTE: remember to replace `include` when issue #4600
# is solved

# orthogonal part
include("Consts/Consts.jl")
include("Utils.jl")
include("Basis/Basis.jl")
include("Lattice/Lattice.jl")

# Depends on Basis.jl
include("Space/Space.jl")

# MCMC part (depends on Basis.jl, Space.jl)
include("Statistics/Statistics.jl")

# Hamiltonian (depends on Lattice.jl, Basis.jl)
include("Hamiltonian/Hamiltonian.jl")

end # module
