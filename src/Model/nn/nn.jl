export nn

module nn

using Compat, StaticArrays, QMTK

include("linear/Linear.jl")

# activations
include("activation/Sigmoid.jl")

end