using QMTK
using Compat.Test

@testset "Constructors" begin

    space = SiteSpace(Bit, (2, 2); nflips=1)
    @test israndomized(space) == true
    typeof(space.data) <: Sites

    space = SiteSpace(Spin, 2, 2; nflips=1)
    @test israndomized(space) == true
    typeof(space.data) <: Sites

    space = SiteSpace(UnRandomized, space)
    @test israndomized(space) == false

end

@testset "methods" begin

    space = SiteSpace(Spin, 2, 2; nflips=1)
    space = reset!(space)
    @test israndomized(space) == false

    @test acquire(space) == space.data
    @test acquire(space) !== space.data

    @test_throws UnRandomizedError shake!(space)

    space = randomize!(space)
    sample = shake!(space)
    @test sample === space.data
end
