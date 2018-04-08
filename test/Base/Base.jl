using QMTK
using Compat.Test

@testset "Sites" begin
    include("Sites.jl")
end

@testset "SubSites" begin
    include("SubSites.jl")
end

@testset "Tags" begin
    include("Tag/Tags.jl")
end
