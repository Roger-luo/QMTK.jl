export Sin

mutable struct Sin{T, O} <: AbstractBlock
    output::O
    Sin{T, O}() where {T, O} = new{T, O}()
end

Sin(::Type{T}, ::Type{O}) where {T, O} = Sin{T, O}()
Sin(::Type{T};nbatch=1) where T = Sin(T, nbatch > 1? Matrix{T} : Vector{T})
Sin(;nbatch=1) = Sin(Float64, nbatch=nbatch)

function forward(op::Sin{T, O}, input::O) where {T, O}
    op.output = sin.(input)    
    return op.output
end

function backward(op::Sin{T, O}, grad::O) where {T <: Real, O}
    grad .* cos.(op.output)
end

function backward(op::Sin{T, O}, grad::O) where {T <: Complex, O}
    grad .* conj(cos.(op.output))
end