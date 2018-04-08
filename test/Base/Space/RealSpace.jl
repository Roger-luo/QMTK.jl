using QMTK
import QMTK: RealSpaceType
using Compat.Test

@test Float64 <: RealSpaceType{Float64}
@test (Float64 <: RealSpaceType{Float32}) == false

@testset "Constructors" begin

# setUp
space = RealSpace()
@test space.data < space.max
@test space.data >= space.min
@test typeof(space.data) <: Float64
@test israndomized(space) == true

space = RealSpace(2, 2, min=-1, max=1)
@test size(space.data) == (2, 2)
@test all(space.data .< 1)
@test all(space.data .>= -1)
@test typeof(space.data) <: Array{Float64, 2}
@test israndomized(space) == true

space = RealSpace(Float32, 2, 2, min=-1, max=1)
@test size(space.data) == (2, 2)
@test all(space.data .< 1)
@test all(space.data .>= -1)
@test typeof(space.data) <: Array{Float32, 2}

end

@testset "initialize" begin

    space = RealSpace()
    space = reset!(space)
    @test space.data == space.min
    @test israndomized(space) == false

    space = RealSpace(2, 2)
    space = reset!(space)
    @test all(space.data .== space.min)
    @test israndomized(space) == false
end
