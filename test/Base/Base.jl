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

@testset "Ket" begin
    include("Ket.jl")
end

@testset "Space" begin
    include("Space/Space.jl")
end
