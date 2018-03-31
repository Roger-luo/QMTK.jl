using QMTK
using Compat.Test
using Compat.Iterators

for shape in (8, 6, 10)
    chain = Chain(Fixed, shape)

    @test collect(1:shape) == collect(sites(chain))

    for K in (1, 3, 5)
        t = map(collect(1:shape-K)) do x
            x, x+K
        end
        @test t == collect(bonds(chain, K))
    end
end
