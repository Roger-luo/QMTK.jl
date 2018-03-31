using QMTK
using Compat.Test
using Compat.Iterators

# # Sites
# for shape in [(3, 4), (3, 3), (4, 5), (1, 5)]
#     square = Square(Fixed, shape)
    
#     for (target, test) in zip(product(1:shape[1], 1:shape[2]), sites(square))
#         @test target == test
#     end
# end

display(collect(product(1:2, 1:4)))

square = Square(Fixed, 3, 4)

println()
display(collect(bonds(square, 1)))
display(collect(QMTK.SquareBondIter(square, Vertical{1})))
println()
display(collect(QMTK.SquareBondIter(square, Horizontal{1})))
println()
display(collect(QMTK.SquareBondIter(square, UpRight{1})))
println()
display(collect(QMTK.SquareBondIter(square, UpLeft{1})))

# for each in bonds(square, 1)
#     @show each
# end
