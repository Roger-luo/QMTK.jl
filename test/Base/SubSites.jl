import QMTK: SubSites, Bit, Spin, Half, data, sitetype
using Compat.Test

@testset "Construction" begin

    @test SubSites(Bit, 1, 0, 1).data == (1, 0, 1)
    @test SubSites(Bit, (1, 0, 1)).data == (1, 0, 1)
    @test eltype(SubSites(Bit, Float32, 1, 0, 1)) == Float32
    @test eltype(SubSites(Bit, Float32, (1, 0, 1))) == Float32

    @test sitetype(SubSites{Bit, Int, 2}) == Bit
    
    self = SubSites(Bit, 1, 0, 1)
    @test data(self) === self.data
end

@testset "Conversions" begin

    for TYPE in (UInt8, UInt16, UInt32, UInt64, UInt128,
                 Int8, Int16, Int32, Int64, Int128)

        @test TYPE(SubSites(Bit, 1, 0, 0)) === TYPE(0b001)
        @test TYPE(SubSites(Bit, 1, 1, 0)) === TYPE(0b011)

        @test TYPE(SubSites(Spin, 1, -1, -1)) === TYPE(0b001)
        @test TYPE(SubSites(Spin, 1,  1, -1)) === TYPE(0b011)

        @test TYPE(SubSites(Half, 0.5, -0.5, -0.5)) === TYPE(0b001)
        @test TYPE(SubSites(Half, 0.5,  0.5, -0.5)) === TYPE(0b011)

    end

    @test convert(SubSites{Bit, Int, 3}, SubSites(Spin, 1, -1, -1)) == SubSites(Bit, 1, 0, 0)
    @test convert(SubSites{Spin, Int, 3}, SubSites(Bit, 1, 0, 0)) == SubSites(Spin, 1, -1, -1)
    @test convert(SubSites{Half, Float64, 3}, SubSites(Bit, 1, 0, 1)) == SubSites(Half, 0.5, -0.5, 0.5)
end
