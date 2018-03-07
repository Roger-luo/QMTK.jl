using QMTK
using Base.Test

@testset "Check Type Property" begin

    # check default eltype
    @test eltype(Bit) == Int8
    @test eltype(Spin) == Int8
    @test eltype(Half) == Float16

    # check up down type
    for each in (Bit, Spin, Half)
        @test typeof(up(each)) == eltype(each)
    end

end

@testset "Check Initialization" begin
    # check initial
    SiteBit = Sites(Bit, 3, 3)
    SiteSpin = Sites(Spin, 3, 3)
    SiteHalf = Sites(Half, 3, 3)

    @test SiteBit.data == zeros(eltype(Bit), 3, 3)
    @test SiteSpin.data == -ones(eltype(Spin), 3, 3)
    @test SiteHalf.data == eltype(Half)(-0.5) * ones(eltype(Half), 3, 3)
end

@testset "Check Array Interface" begin

    SHAPE = (3, 4)
    LENGTH = prod(SHAPE)
    SiteA = Sites(Bit, SHAPE)

    @test eltype(SiteA) == eltype(Bit)
    @test length(SiteA) == LENGTH
    @test ndims(SiteA) == length(SHAPE)
    @test size(SiteA) == SHAPE
    @test size(SiteA, 1) == SHAPE[1]
    @test size(SiteA, 2) == SHAPE[2]
    @test indices(SiteA) == indices(SiteA.data)
    @test indices(SiteA, 1) == indices(SiteA.data, 1)
    @test eachindex(SiteA) == eachindex(SiteA.data)
    @test stride(SiteA, 1) == stride(SiteA.data, 1)
    @test strides(SiteA) == strides(SiteA.data)
    @test getindex(SiteA, 1, 1) == SiteA.data[1, 1]

    setindex!(SiteA, 2, 1, 1)
    @test SiteA[1, 1] == 2
end

@testset "Check Site Interface" begin
    SHAPE = (3, 4)
    SiteA = Sites(Bit, SHAPE)
    SiteB = copy(SiteA)

    # check if this copy is shallow
    rand!(SiteA)
    @test SiteB[1, 1] == 0

    reset!(SiteA)
    @test SiteA.data == zeros(eltype(Bit), SHAPE)

    SiteB[1, 1] = up(Bit)
    @test flip!(SiteA, 1, 1) == SiteB
end

@testset "Check Site Conversions" begin

    for LT in (Bit, Spin, Half)
        A = Sites(LT, 4, 4)
        set!(A, 142)

        @test convert(Int, A) == 142
        
        # will throw InexactError if Sites is too large
        @test_throws InexactError convert(Int8, A)
    end

end

@testset "Check SubSite Conversions" begin
    @test convert(Int, SubSites(Bit, 0, 0)) == 0
    @test convert(Int, SubSites(Spin, -1, -1)) == 0
    @test convert(Int, SubSites(Half, -0.5, -0.5)) == 0

    @test convert(Int, SubSites(Bit, 1, 0)) == 2
    @test convert(Int, SubSites(Spin, 1, -1)) == 2
    @test convert(Int, SubSites(Half, 0.5, -0.5)) == 2

    @test convert(SubSites{Bit, eltype(Bit), 2}, 0) == SubSites(Bit, 0, 0)
    @test convert(SubSites{Bit, eltype(Bit), 2}, 2) == SubSites(Bit, 1, 0)

    @test convert(SubSites{Spin, eltype(Spin), 2}, 0) == SubSites(Spin, -1, -1)
    @test convert(SubSites{Spin, eltype(Spin), 2}, 2) == SubSites(Spin,  1, -1)

    @test convert(SubSites{Half, eltype(Half), 2}, 0) == SubSites(Half, -0.5, -0.5)
    @test convert(SubSites{Half, eltype(Half), 2}, 2) == SubSites(Half,  0.5, -0.5)
end
