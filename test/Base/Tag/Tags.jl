using Compat.Test

@testset "Site Tag" begin
    include("Site.jl")
end

@testset "Space Tag" begin
    include("Space.jl")
end

@testset "Lattice Tag" begin
    include("Lattice.jl")
end

@testset "General Tag" begin
    include("General.jl")
end
