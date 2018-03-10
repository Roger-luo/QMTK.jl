linear_input_type(x::T, nbatch) where T = linear_input_type(T, nbatch)

linear_input_type(::Type{Matrix{T}}, nbatch) where T = nbatch > 1? Matrix{T} : Vector{T}
linear_input_type(::Type{SparseMatrixCSC{Tv, Ti}}, nbatch) where {Tv, Ti} =
    nbatch > 1? SparseMatrixCSC{Tv, Ti} : SparseVector{Tv, Ti}

function linear_input_type(::Type{SArray{Tuple{out, in}, T, 2, L}}, nbatch) where {out, in, T, L}
    if nbatch > 1
        return SArray{Tuple{in, nbatch}, T, 2, in}
    else
        return SArray{Tuple{in}, T, 1, in}
    end
end

function linear_input_type(::Type{MArray{Tuple{out, in}, T, 2, L}}, nbatch) where {out, in, T, L}
    if nbatch > 1
        return MArray{Tuple{in, nbatch}, T, 2, in}
    else
        return MArray{Tuple{in}, T, 1, in}
    end
end

# TODO: GPU array
function linear_input_type end
