mutable struct Gaussian{T, RT <: Real, O} <: AbstractBlock
    μ::T
    σ::RT
    grad_μ::T
    grad_σ::RT

    input::O
    output::O

    Gaussian{T, RT, O}(mu, sigma) where {T, RT, O} =
        new{T, RT, O}(mu, sigma, zero(T), zero(RT))
end

Gaussian(::Type{O}, mu::T, sigma::RT) where {T, RT, O} =
    Gaussian{T, real(T), O}(mu, sigma)

Gaussian(mu::T, sigma::RT; nbatch=1) where {T, RT} =
    Gaussian(nbatch > 1? Matrix{T} : Vector{T}, mu, sigma)

# TODO: check if generated function will be faster (probably not)
function forward(op::Gaussian{T, RT, O}, input::O) where {T, RT, O}
    op.input = input
    factor = 1 / (sqrt(2 * pi) * op.σ)
    op.output = factor .* exp.(- abs2.(input .- op.μ) ./ (2 * op.σ^2))
    return op.output
end

function backward(op::Gaussian{T, RT, O}, grad::O) where {T <: Complex, RT, O}
    op.grad_μ = sum(real(op.input .- op.μ) .* op.output ./ op.σ^2 .* grad) # Trust your compiler
    op.grad_σ = sum(((abs2(op.input .- op.μ)) .- op.σ^2) ./ op.σ^3 .* op.output .* grad)
    return -(conj(op.input .- op.μ) .* op.output) ./ op.σ^2 .* grad
end
