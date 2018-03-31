__precompile__()

module QMTK
using Compat
using Compat.SparseArrays
using Compat.Random

"""
    __version__

QMTK version number
"""
const __version__ = v"0.1.0"
# NOTE: remember to replace `include` when issue #4600
# is solved

# orthogonal part
include("Consts/Consts.jl")
include("Utils.jl")
include("Base/Base.jl")

# Depends on Base.jl
include("Lattice/Lattice.jl")
include("Sample/Sample.jl")

# Hamiltonian (depends on Lattice.jl, Basis.jl)
include("Hamiltonian/Hamiltonian.jl")

# Model
include("Model/Model.jl")

end # module
