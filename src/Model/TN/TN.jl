export TN

"""
# a tiny coarse-grained tensor network framework
"""
module TN

import QMTK: forward, backward
using Compat, StaticArrays, QMTK

include("MPS.jl")

end