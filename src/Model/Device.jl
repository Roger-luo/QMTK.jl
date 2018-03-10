export device, GPU, CPU

abstract type AbstractDevice end
abstract type CPU <: AbstractDevice end
abstract type GPU{N} <: AbstractDevice end

device(x::T) where T = device(T)
device(::Type{T}) where T = CPU

import Base: show

show(io::IO, d::Type{CPU}) = print(io, "CPU")
show(io::IO, d::Type{GPU{N}}) where N = print(io, "GPU{$N}")
