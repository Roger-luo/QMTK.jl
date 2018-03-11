using QMTK
using Compat.Test


@testset "Basic Interface" begin

    @test isperiodic(Chain{Fixed}(10)) == false
    @test isperiodic(Square{Fixed}(10, 10)) == false

    @test isperiodic(Chain{Periodic}(10)) == true
    @test isperiodic(Square{Periodic}(10, 10)) == true

    @test shape(Chain{Fixed}(10)) == (10, )
    @test shape(Square{Fixed}(10, 10)) == (10, 10)

end # testset

@testset "Chain Iterator" begin

    function chain_sites(chain::Chain)
        data = []
        for i = 1:chain.length
            push!(data, i)
        end
        return data
    end

    function chain_bonds(chain::Chain{Fixed}, N::Int)
        data = []
        for i = 1:chain.length-N
            push!(data, (i, i+N))
        end
        return data
    end

    function chain_bonds(chain::Chain{Periodic}, N::Int)
        data = []
        for i = 1:chain.length
            push!(data, (i, (i+N)%chain.length))
        end
        return data
    end

    for shape in (3, 4, 5, 6), BC in (Fixed, Periodic)
        chain = Chain(BC, shape)
        for N in (1, 2, 3)
            for (each, std) in zip(bonds(chain, N), chain_bonds(chain, N))
                @test each == std
            end
        end

        for (each, std) in zip(sites(chain), chain_sites(chain))
            @test each == std
        end
    end
end

@testset "Square Iterator" begin

    function square_sites(square::Square)
        data = []
        for i=1:square.width, j=1:square.height
            push!(data, (i, j))
        end
        return data
    end

    function square_bonds(square::Square, N::Int)
        if N % 2 == 0
            square_bonds(square, QMTK.Even, N / 2)
        else
            square_bonds(square, QMTK.Odd, (N + 1) / 2)
        end
    end

    square_bonds(square::Square, ::Type{T}, K::Float64) where T =
        square_bonds(square, T, convert(Int, K))

    function square_bonds(square::Square{Fixed}, ::Type{QMTK.Odd}, K::Int)
        data = []
        for i = 1:(square.width-K), j = 1:square.height
            push!(data, ((i, j), (i+K, j)))
        end

        for j = 1:(square.height-K), i = 1:square.width
            push!(data, ((i, j), (i, j+K)))
        end

        return data
    end

    function square_bonds(square::Square{Fixed}, ::Type{QMTK.Even}, K::Int)
        data = []
        
        for i = 1:(square.width-K), j = 1:(square.height-K)
            push!(data, ((i, j), (i+K, j+K)))
        end

        for j = 1:(square.height-K), i = 1:(square.width-K)
            push!(data, ((i+K, j), (i, j+K)))
        end

        return data
    end

    function square_bonds(square::Square{Periodic}, ::Type{QMTK.Odd}, K::Int)
        data = []
        for i = 1:square.width, j = 1:square.height
            push!(data, ((i, j), ((i-1+K) % square.width + 1, j)))
        end

        for j = 1:square.height, i = 1:square.width
            push!(data, ((i, j), (i, (j-1+K) % square.height + 1)))
        end
        return data
    end

    function square_bonds(square::Square{Periodic}, ::Type{QMTK.Even}, K::Int)
        data = []

        for i = 1:square.width, j = 1:square.height
            push!(data, ((i, j), ((i+K-1)%square.width+1, (j+K-1)%square.height+1)))
        end

        for j = 1:square.height, i = 1:square.width
            push!(data, (((i+K-1)%square.width+1, j), (i, (j+K-1)%square.height+1)))
        end

        return data
    end

    for shape in ((3, 3), (3, 4), (5, 5), (3, 5)), BC in (Fixed, Periodic)
        square = Square(BC, shape)

        for i = 1:4
            data = square_bonds(square, i)

            for (impl, std) in zip(bonds(square, i), data)
                @test impl == std
            end
        end

        for (each, std) in zip(sites(square), square_sites(square))
            @test each == std
        end

    end

end # testset
