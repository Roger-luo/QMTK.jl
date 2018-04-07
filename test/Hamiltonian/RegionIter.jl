using QMTK
using QMTK.Consts.Pauli
using Compat.Test

@testset "Region Iterator" begin

    chain = Chain(Fixed, 5)
    t = kronsum(bonds(chain, 1)) do i, j
        :(σ₁[$i] ⊗ σ₂[$j])
    end

    for i = 1:3
        rhs = rand(Bit, 5)
        h = LocalHamiltonian(Region{1}, σ₁ ⊗ σ₂)
        itr = RegionIterator(h, chain, rhs)

        rhs_idx = convert(Int, rhs) + 1
        for (val, lhs) in RegionIterator(h, chain, rhs)
            lhs_idx = convert(Int, lhs) + 1
            @test val == t[lhs_idx, rhs_idx]
        end
    end

    ###

    square = Square(Fixed, 4, 4)
    t = kronsum(bonds(square, 1)) do i, j
        :(σ₁[$i] ⊗ σ₂[$j])
    end

    for i=1:3
        rhs = rand(Bit, 4, 4)
        h = LocalHamiltonian(Region{1}, σ₁ ⊗ σ₂)
        itr = RegionIterator(h, square, rhs)

        rhs_idx = convert(Int, rhs) + 1
        for (val, lhs) in RegionIterator(h, square, rhs)
            lhs_idx = convert(Int, lhs) + 1
            @test val == t[lhs_idx, rhs_idx]
        end
    end

    chain = Chain(Periodic, 5)
    t = kronsum(bonds(chain, 1)) do i, j
        :(σ₁[$i] ⊗ σ₂[$j])
    end

    for i = 1:3
        rhs = rand(Bit, 5)
        h = LocalHamiltonian(Region{1}, σ₁ ⊗ σ₂)
        itr = RegionIterator(h, chain, rhs)

        rhs_idx = convert(Int, rhs) + 1
        for (val, lhs) in RegionIterator(h, chain, rhs)
            lhs_idx = convert(Int, lhs) + 1
            @test val == t[lhs_idx, rhs_idx]
        end
    end

    ###

    square = Square(Periodic, 4, 4)
    t = kronsum(bonds(square, 1)) do i, j
        :(σ₁[$i] ⊗ σ₂[$j])
    end

    for i=1:3
        rhs = rand(Bit, 4, 4)
        h = LocalHamiltonian(Region{1}, σ₁ ⊗ σ₂)
        itr = RegionIterator(h, square, rhs)

        rhs_idx = convert(Int, rhs) + 1
        for (val, lhs) in RegionIterator(h, square, rhs)
            lhs_idx = convert(Int, lhs) + 1
            @test val == t[lhs_idx, rhs_idx]
        end
    end

end
