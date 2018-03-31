using QMTK
using Compat.Test
using Compat.Iterators


@testset "Basic Interface" begin

    @test isperiodic(Chain{Fixed}(10)) == false
    @test isperiodic(Square{Fixed}(10, 10)) == false

    @test isperiodic(Chain{Periodic}(10)) == true
    @test isperiodic(Square{Periodic}(10, 10)) == true

    @test shape(Chain{Fixed}(10)) == (10, )
    @test shape(Square{Fixed}(10, 10)) == (10, 10)

    @test length(Chain{Fixed}(10)) == 10
    @test length(Square{Fixed}(10, 10)) == 100

end # testset

@testset "Chain Lattice" begin
    include("Chain.jl")
end

@testset "Square Lattice" begin
    include("Square.jl")
end
