using QMTK
using Compat.Test
using Compat.Iterators

SHAPES = [(3, 4), (3, 3), (4, 5), (1, 5)]

# Sites
for shape in SHAPES
    for bound in (Fixed, Periodic)
        square = Square(bound, shape)
        @test collect(product(1:shape[1], 1:shape[2])) == collect(sites(square))
    end
end

# Vertical
for shape in SHAPES
    square = Square(Fixed, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1]-K, 1:shape[2]))) do x
            x, (x[1] + K, x[2])
        end
        @test t == collect(QMTK.SquareBondIter(square, Vertical{K}))
    end
end

# Horizontal
for shape in SHAPES
    square = Square(Fixed, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1], 1:shape[2]-K))) do x
            x, (x[1], x[2]+K)
        end
        @test t == collect(QMTK.SquareBondIter(square, Horizontal{K}))
    end
end

# UpRight
for shape in SHAPES
    square = Square(Fixed, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1]-K, 1:shape[2]-K))) do x
            x, (x[1]+K, x[2]+K)
        end
        @test t == collect(QMTK.SquareBondIter(square, UpRight{K}))
    end
end

# UpLeft
for shape in SHAPES
    square = Square(Fixed, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1]-K, 1:shape[2]-K))) do x
            (x[1]+K, x[2]), (x[1], x[2]+K)
        end
        @test t == collect(QMTK.SquareBondIter(square, UpLeft{K}))
    end
end

# Periodic
# Vertical
for shape in SHAPES
    square = Square(Periodic, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1], 1:shape[2]))) do x
            x, ((x[1]+K-1)%shape[1]+1, x[2])
        end
        @test t == collect(QMTK.SquareBondIter(square, Vertical{K}))
    end
end

# Horizontal
for shape in SHAPES
    square = Square(Periodic, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1], 1:shape[2]))) do x
            x, (x[1], (x[2]+K-1)%shape[2]+1)
        end
        @test t == collect(QMTK.SquareBondIter(square, Horizontal{K}))
    end
end

# UpRight
for shape in SHAPES
    square = Square(Periodic, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1], 1:shape[2]))) do x
            x, ((x[1]+K-1)%shape[1]+1, (x[2]+K-1)%shape[2]+1)
        end
        @test t == collect(QMTK.SquareBondIter(square, UpRight{K}))
    end
end

# UpLeft
for shape in SHAPES
    square = Square(Periodic, shape)
    for K = 1:3
        t = map(collect(product(1:shape[1], 1:shape[2]))) do x
            ((x[1]+K-1)%shape[1]+1, x[2]), (x[1], (x[2]+K-1)%shape[2]+1)
        end
        @test t == collect(QMTK.SquareBondIter(square, UpLeft{K}))
    end
end