using Compat.Test

@testset "Core" begin
    include("Core.jl")
end

@testset "RegionIter" begin
    include("RegionIter.jl")
end

# @testset "kron macros" begin
#     include("KronMacro.jl")
# end


