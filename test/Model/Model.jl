using Compat.Test

@testset "Neural Network" begin
    include("NN/NN.jl")
end

@testset "Tensor Network" begin
    include("TN/TN.jl")
end

@testset "Quantum Circuit" begin
    include("QuCircuit/QuCircuit.jl")
end
