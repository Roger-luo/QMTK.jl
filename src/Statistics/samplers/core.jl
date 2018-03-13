import Base: show
import Compat.Distributed: AbstractWorkerPool

# abstracts
export AbstractSampler, SamplerState

export SamplePlan

# Interface
export state, update!, sample!

"""
Abstract type for all samplers

## Interface

- `show(io::IO, sampler)`: print verbose information for a sampler
- `algorithm(sampler) -> String`: print algorithm name
- `state(sampler) -> SamplerState`: get sampler state
"""
abstract type AbstractSampler end

"""
Abstract type for all sampler state
"""
abstract type SamplerState end

"""
Sample Plan contains a distribution and a sampler.

## Interface

- `state(plan::SamplePlan) -> SamplerState`: get sampler's state
- `update!(plan::SamplePlan) -> SamplePlan`: update sample plan according to the sampler
- `show(plan::SamplePlan)`: print verbose information

## Note

using a list of distribution (probability) is also allowed. This means you have
to define your list type as a subtype of `AbstractVector` and it has to support
`getindex` method at least.

using a `Function` as your distribution is more common. And you can define your
custom type of distribution function by define a subtype of `Function` with its
`call` method (AKA `function (f::YourFunctionType)(x)`).
"""
struct SamplePlan{S<:AbstractSampler, D}
    distribution::D
    sampler::S
end

"""
    state(plan)

get sampler's state in `SamplePlan`
"""
state(plan::SamplePlan) = state(plan.sampler)


"""
    update!(plan)

update plan accroding to certain sampler
"""
function update!(plan::SamplePlan) end

"""
    sample!(plan) -> data

execute your sample plan
"""
function sample!(plan::SamplePlan) end

"""
    sample!(pool, plan; nchain=4) -> data

execute your sample plan according to a `WorkPool`
"""
sample!(pool::AbstractWorkerPool, plan::SamplePlan; nchain=4) =
    pmap(pool, x->sample!(plan), 1:nchain)

"""
    sample!(nchain, plan) -> data

execute your sample plan in parallel, with `n` chains.
"""
sample!(nchain::Int, plan::SamplePlan) = 
    pmap(x->sample!(plan), 1:nchain)


function show(io::IO, plan::SamplePlan{S, D}) where {S<:AbstractSampler, D<:Function}
    println(io, "Sample Plan:")
    println("Algorithm: $(algorithm(plan.sampler))")
    print("Distribution Type: Function Distribution")
end

function show(io::IO, plan::SamplePlan{S, D}) where {S<:AbstractSampler, D<:AbstractVector}
    println(io, "Sample Plan:")
    println("Algorithm: $(algorithm(plan.sampler))")
    print("Distribution Type: Probability List")
end

### sugars

"""
    sample(expr)

a sugar macro to construct a `SamplePlan`
"""
macro sample(expr)
    warn("Not Implemented")
end

include("metropolis.jl")
