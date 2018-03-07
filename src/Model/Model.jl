# Coarse-grained autodiff for models

abstract type AbstractModel end

function forward end
function backward end

struct Variable{T}
    data::T
    grad::T
end

include("Linear.jl")
