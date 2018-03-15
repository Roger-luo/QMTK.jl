using QMTK
using BenchmarkTools

@generated function _kronprod(list...)
    ex = Expr(:call, :kron, :(list[1]), :(list[2]))
    for i in 3:length(list)
        ex = Expr(:call, kron, ex, :(list[$i]))
    end
    return ex
end

const sigmax = sprand(10, 10, 0.5)
⊗ = kron

println("--------------------")
println("baseline")
display(@benchmark kron(kron(kron(sigmax, sigmax), sigmax), sigmax))
println("--------------------")
println("QMTK")
display(@benchmark kronprod(sigmax, sigmax, sigmax, sigmax))
println("--------------------")
println("generated")
display(@benchmark _kronprod(sigmax, sigmax, sigmax, sigmax))
println("--------------------")
println("product")
display(@benchmark sigmax ⊗ sigmax ⊗ sigmax ⊗ sigmax)
