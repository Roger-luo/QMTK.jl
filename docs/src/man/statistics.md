# [Statistics](@id man-statistics)

## Sampler

Samplers are certain type contains a sample space of `AbstractSpace` and some other parameters (like the number of iterations and etc.). For a given sampler on certain space, you can specify the sampling task by
make a `SamplePlan`. A sample plan is a type contains the desired distribution and the sampler. To execute a `SamplePlan`, just simply use `sample!`, or you could call `update!` to run only one iteration.

A possible example could be

```julia
space = RealSpace(min=-4, max=4)
sampler = MHSampler(space)

@everywhere function normal(x::T) where T <: Real
    factor = 1 / sqrt(2 * pi)
    return factor * exp(- x^2/2)
end

plan = SamplePlan(normal, sampler)
data = sample!(plan)
# run parallel
# data = sample!(4, plan)
# or run with customed workerpool
# data = sample!(pool, plan)
```

the macro `@everywhere` here is used to declare this function on different process, you won't need it if there is only one process.

```@docs
AbstractSampler
SamplerState
SamplePlan
state(plan::SamplePlan)
update!(plan::SamplePlan)
sample!(plan::SamplePlan)
sample!(pool::Distributed.AbstractWorkerPool, plan::SamplePlan; nchain=4)
sample!(nchain::Int, plan::SamplePlan)
MHSampler
```