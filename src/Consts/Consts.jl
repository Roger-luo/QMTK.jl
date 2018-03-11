export Consts

"""
Physical Constants.

You can access NIST CODATA Fundamental Physical Constants
Through this module. Be careful, when using `using` to import
this module, there could be conflict.
"""
module Consts

using Compat

macro __DATA__()
    return joinpath(dirname(dirname(@__DIR__)), "data")
end

mkpath(@__DATA__)
DATA = Dict{String, Any}()

include("Utils.jl")
include("Core.jl") # Defined Type Hierachy

# Constants
include("NIST.jl")
include("Defined.jl")
include("Pauli.jl")

end # module
