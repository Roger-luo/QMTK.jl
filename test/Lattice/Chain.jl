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
        itr = bonds(chain, K)
        @test chain == lattice(itr)
        @test t == collect(itr)
    end
end

for shape in (8, 6, 10)
    chain = Chain(Periodic, shape)

    @test collect(1:shape) == collect(sites(chain))

    for K in (1, 3, 5)
        t = map(collect(1:shape)) do x
            x, (x+K-1)%shape+1
        end
        itr = bonds(chain, K)
        @test chain == lattice(itr)
        @test t == collect(bonds(chain, K))
    end
end
