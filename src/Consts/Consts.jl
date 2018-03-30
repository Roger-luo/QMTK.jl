export Consts

"""
    Consts

Physical Constants. You can access NIST CODATA Fundamental Physical Constants
Through this module. Be careful, when using `using` to import
this module, there could be conflict.
"""
module Consts

using Compat
export DATA

macro __DATA__()
    joinpath(dirname(dirname(@__DIR__)), "data")
end

mkpath(@__DATA__)
DATA = Dict{String, Any}()

include("DataFile.jl")

# General Type Hierachy
include("Core.jl")
include("NIST.jl")
include("Defined.jl")

# Load Data
DATAFILES = Dict{String, DataFile}()
DATAFILES["NIST"] = DataFile(
    "https://nist.gov/srd/srd_data//srd121_allascii_2014.json",
    @__DATA__,
    "srd121_allascii_2014.json"
)
obtain(DATAFILES["NIST"])

# Constants Alias
include("Universal.jl")
include("Pauli.jl")

end # module
