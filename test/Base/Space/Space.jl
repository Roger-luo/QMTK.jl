using Compat.Test

@testset "Real Space" begin
    include("RealSpace.jl")
end

@testset "Site Space" begin
    include("SiteSpace.jl")
end
