export MHState, MHSampler, isburned

mutable struct MHState{SampleType} <: SamplerState
    curr::SampleType
    posterior::Float64

    burned::Bool
end

MHState(curr::ST) where {ST} = MHState{ST}(curr, 1.0, false)
MHState(space::AbstractSpace) = MHState(copy(shake!(space)))
isburned(state::MHState) = state.burned

collect!(dataset::AbstractArray{ST}, sample::ST) where {ST} = 
    push!(dataset, copy(sample))
collect!(dataset::AbstractArray{ST}, state::MHState{ST}) where {ST} = 
    collect!(dataset, state.curr)

"""
`MHSampler` uses Metropolis-Hasting algorithm to sample
a proposal distribution for sample type `ST`
"""
mutable struct MHSampler{SampleType} <: AbstractSampler
    space::AbstractSpace{SampleType, Randomized}

    itr::Int
    burn::Int
    thin::Int

    state::MHState{SampleType}
end

"""
This is a temporary function to decide the number of burn itrations.

``20\\cdot log(itr)``

TODO: find something better
"""
_empirical_burn_itr(itr) = 20 * (itr|>log|>floor|>Int)

function MHSampler(space::AbstractSpace{ST, Randomized}; itr=1000, burn=300, thin=1) where {ST}
    @assert itr > burn "too many burn-in samples"
    return MHSampler{ST}(space, itr, burn, thin, MHState(space))
end

algorithm(sampler::MHSampler) = "Metropolis-Hasting"
state(sampler::MHSampler) = sampler.state

function show(io::IO, sampler::MHSampler{ST}) where {ST}
    print(io, "Metropolis-Hasting\n")
    print(io, "------------------\n")
    print(io, " nitr: $(sampler.itr)\n")
    print(io, " nburn: $(sampler.burn)\n")
    print(io, " thin: $(sampler.thin)")
end

function update!(sampler::MHSampler{ST}, cand::ST, prob::Real) where {ST}
    accept = 1.0
    state = sampler.state

    # Julia can handle Inf itself
    accept = min(1.0, prob / state.posterior)

    if rand() < accept
        state.curr = copy(cand)
        state.posterior = prob
    end
    return sampler
end

function update!(plan::SamplePlan{MHSampler{ST}, D}) where {ST, D <: Function}
    sampler = plan.sampler
    
    cand_state = shake!(sampler.space)
    cand_prob = plan.distribution(cand_state)

    update!(sampler, cand_state, cand_prob)
    return plan
end

function update!(plan::SamplePlan{MHSampler{ST}, D}) where {ST, D <: AbstractVector}
    sampler = plan.sampler

    cand_state = shake!(sampler.space)
    cand_prob = plan.distribution[cand_state]

    update!(sampler, cand_state, cand_prob)
    return plan
end

function burn!(plan::SamplePlan{MHSampler{ST}, D}) where {ST, D}
    for i = 1:plan.sampler.burn
        update!(plan)
    end

    plan.sampler.state.burned = true
end

function sample!(plan::SamplePlan{MHSampler{ST}, D}) where {ST, D}
    if !isburned(plan.sampler.state)
        burn!(plan)
    end

    dataset = ST[]
    for i = 1:plan.sampler.itr
        update!(plan)
        collect!(dataset, state(plan))
    end
    return dataset
end
