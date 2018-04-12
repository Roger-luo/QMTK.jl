export NN

"""
# a tiny coarse-grained neural network framework

The `nn` module only offers a protocal to calculate
neural networks on any array type of Julia that overloads
the interface of `AbtractArray`.

You can use native `Array`, `AbstractSparseArray`, and also
`StaticArray` for small calculations. Moreover, you can also
use GPU arrays, like `ArrayFire`, `CuArray` and etc.

NOTE: GPU part is under development.

each subtype of `AbstractModel` has the following interface

    forward(operator, input)

For some block/operators/models, the forward method will record the input
and output value for backward use, thus, be careful, make sure you provide
a new array with differnet reference to input for the output of forward, or
the content stored for backward may change.

    backward(operator, grad)

backward method will calculate gradient, it will store parameter gradient into
the operator and return the gradient of input.
"""
module NN

import QMTK: forward, backward
using Compat, StaticArrays, QMTK

include("linear/Linear.jl")

# activations
include("activation/Activation.jl")

end