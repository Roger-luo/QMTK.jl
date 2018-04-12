export AbstractModel, AbstractBlock
export forward, backward

import Base: show, size

abstract type AbstractModel end
abstract type AbstractBlock <: AbstractModel end

size(x::AbstractModel) = 0

function forward end
function backward end

include("Utils.jl")

include("Device.jl")
include("NN/NN.jl")
include("TN/TN.jl")
