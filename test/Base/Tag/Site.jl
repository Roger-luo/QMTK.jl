using QMTK
using Compat.Test


@test eltype(Spin) == Float32
@test eltype(Bit) == Float32
@test eltype(Half) == Float32

@test up(Spin) == 1
@test down(Spin) == -1

@test up(Bit) == 1
@test down(Bit) == 0

@test up(Half) == 0.5
@test down(Half) == -0.5

@test is(Spin, -1) == true
@test is(Spin,  1) == true
@test is(Spin, 2) == false

@test is(Bit,  1) == true
@test is(Bit,  0) == true
@test is(Bit, -1) == false
@test is(Bit, 0.5) == false

@test is(Half,  0.5) == true
@test is(Half, -0.5) == true
@test is(Half,  1.0) == false
@test is(Half, -1.0) == false
