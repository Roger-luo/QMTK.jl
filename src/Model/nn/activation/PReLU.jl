mutable struct PReLU{T, O} <: AbstractBlock
    weight::T
    output::O
    PReLU{T, O}(weight::T) where {T, O} = new{T, O}(weight)
end


