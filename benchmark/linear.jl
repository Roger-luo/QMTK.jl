using BenchmarkTools

# Conclusion
# `BLAS.gemv!` is a little bit faster than native operators.

# --------Native---------
# BenchmarkTools.Trial: 
#   memory estimate:  156.41 KiB
#   allocs estimate:  4
#   --------------
#   minimum time:     51.991 ms (0.00% GC)
#   median time:      53.109 ms (0.00% GC)
#   mean time:        53.112 ms (0.00% GC)
#   maximum time:     54.377 ms (0.00% GC)
#   --------------
#   samples:          95
#   evals/sample:     1
# --------BLAS-----------
# BenchmarkTools.Trial: 
#   memory estimate:  0 bytes
#   allocs estimate:  0
#   --------------
#   minimum time:     52.967 ms (0.00% GC)
#   median time:      56.853 ms (0.00% GC)
#   mean time:        56.331 ms (0.00% GC)
#   maximum time:     59.947 ms (0.00% GC)
#   --------------
#   samples:          89
#   evals/sample:     1

begin

weight = rand(10000, 10000)
bias = rand(10000)
x = rand(10000)

# whether gemv is faster

# Native Julia
native = @benchmark weight * x + bias

y = copy(bias)
blas = @benchmark BLAS.gemv!('N', 1.0, weight, x, 1.0, y)

println("--------Native---------")
display(native)
println("\n--------BLAS-----------")
display(blas)

end

# --------Native---------
# BenchmarkTools.Trial: 
#   memory estimate:  2.98 GiB
#   allocs estimate:  6
#   --------------
#   minimum time:     1.692 s (3.60% GC)
#   median time:      1.768 s (7.84% GC)
#   mean time:        1.761 s (7.52% GC)
#   maximum time:     1.824 s (10.85% GC)
#   --------------
#   samples:          3
#   evals/sample:     1
# --------BLAS-----------
# BenchmarkTools.Trial: 
#   memory estimate:  156.33 KiB
#   allocs estimate:  2
#   --------------
#   minimum time:     100.829 ms (0.00% GC)
#   median time:      109.566 ms (0.00% GC)
#   mean time:        107.981 ms (0.00% GC)
#   maximum time:     112.653 ms (0.00% GC)
#   --------------
#   samples:          47
#   evals/sample:     1

begin

weight = rand(Complex128, 10000, 10000)
dz = rand(Complex128, 10000)
native = @benchmark gradOutput = conj(transpose(weight)) * dz
blas = @benchmark gradOutput = BLAS.gemv('C', weight, dz)

println("\n--------Native---------")
display(native)
println("\n--------BLAS-----------")
display(blas)

end

# backward
begin

# --------Native---------
# BenchmarkTools.Trial: 
#   memory estimate:  1.49 GiB
#   allocs estimate:  2
#   --------------
#   minimum time:     584.670 ms (1.69% GC)
#   median time:      627.907 ms (7.79% GC)
#   mean time:        628.836 ms (8.26% GC)
#   maximum time:     672.612 ms (14.50% GC)
#   --------------
#   samples:          8
#   evals/sample:     1
# --------BLAS-----------
# BenchmarkTools.Trial: 
#   memory estimate:  1.49 GiB
#   allocs estimate:  6
#   --------------
#   minimum time:     418.717 ms (2.36% GC)
#   median time:      479.637 ms (13.84% GC)
#   mean time:        488.342 ms (14.29% GC)
#   maximum time:     561.557 ms (11.78% GC)
#   --------------
#   samples:          11
#   evals/sample:     1%

input = rand(Complex128, 10000)
dz = rand(Complex128, 10000)

function native_backward(input, dz)
    return dz * conj(transpose(input))
end

function blas_backward(input::Vector, dz::Vector)
    input = reshape(input, size(input, 1), 1)
    dz = reshape(dz, size(dz, 1), 1)
    BLAS.gemm('N', 'C', dz, input)
end

native = @benchmark output = native_backward($input, $dz)
blas = @benchmark ouput = blas_backward($input, $dz)

println("\n--------Native---------")
display(native)
println("\n--------BLAS-----------")
display(blas)

end # backward