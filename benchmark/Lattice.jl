using BenchmarkTools
using QMTK

macro section(name, expr)
    println("[Section]: $name")
    return expr
end

macro median(name, expr)
    return :(println("[$($name)]: $(median($expr).time) ns (median)"))
end

@section "Chain Lattice" begin

length = 1000

cache = 0
baseline = @benchmark for i=1:length
    i
end

chain = Chain{Fixed}(length)
cache = 0
results = @benchmark for each in sites(chain)
    each
end

@median "Baseline.sites" baseline
@median "QMTK.sites" results

baseline = @benchmark for i=1:length
    i, i+1
end

results = @benchmark for each in bonds(chain, 1)
    each
end

@median "Baseline.bonds" baseline
@median "QMTK.bonds" results


end


@section "Square Lattice" begin

shape = (30, 30)

baseline = @benchmark for i=1:shape[1], j=1:shape[2]
    i, j
end

square = Square{Fixed}(shape)
results = @benchmark for each in sites(square)
    each
end

@median "Baseline.sites" baseline
@median "QMTK.sites" results

results = @benchmark [each for each in bonds(square, 1)]

# TODO: add baseline
# @median "Baseline.bonds" baseline
@median "QMTK.bonds" results


end