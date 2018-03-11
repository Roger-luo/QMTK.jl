using QMTK
using Compat.Test
using Compat.Distributed

@testset "Metropolis-Hasting" begin

space = RealSpace(min=-4, max=4)
sampler = MHSampler(space)

@everywhere function normal(x::T) where T <: Real
    factor = 1 / sqrt(2 * pi)
    return factor * exp(- x^2/2)
end

plan = SamplePlan(normal, sampler)
data = sample!(plan)

@test length(data) == 1000

end