export nn

"""
# a tiny coarse-grained neural network framework

The `nn` module only offers a protocal to calculate
neural networks on any array type of Julia that overloads
the interface of `AbtractArray`.

You can use native `Array`, `AbstractSparseArray`, and also
`StaticArray` for small calculations. Moreover, you can also
use GPU arrays, like `ArrayFire`, `CuArray` and etc.

NOTE: GPU part is under development.

"""
module nn

import QMTK: forward, backward
using Compat, StaticArrays, QMTK

include("linear/Linear.jl")

# activations
include("activation/Activation.jl")

end