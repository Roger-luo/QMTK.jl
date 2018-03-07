using QMTK
using Base.Test

@testset "Check Real Space" begin
    space = RealSpace()

    @test israndomized(space) == true

    space = reset!(space)
    @test israndomized(space) == false
end


@testset "Check Site Space" begin

    space = SiteSpace(Bit, 2, 2)
    @test israndomized(space) == true
    space = reset!(space)
    @test israndomized(space) == false

    # should not support roll a unrandomized space
    @test_throws UnRandomizedError roll!(space)

    space = rand!(space)
    @test israndomized(space) == true

    old_one = acquire(space)
    @test typeof(roll!(space)) <: Sites

    new_one = acquire(space)
    @test new_one != old_one

    # only flip one
    @test sum(old_one.!=new_one) == 1

    space = SiteSpace(Bit, 3, 3, nflips=4)
    old_one = acquire(space)
    @test typeof(roll!(space)) <: Sites
    new_one = acquire(space)
    @test sum(old_one.!=new_one) == 4

end