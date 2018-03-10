export addbmm, addbmm!, bmm!, bmm

function bmm!(tA::Char, tB::Char, result::Array{T, 2}, alpha::T, batch1::Array{T, 3}, batch2::Array{T, 3}) where T
    @assert size(batch1, 3) == size(batch2, 3) "batch size does not match"

    batch = size(batch1, 3)
    for i = 1:batch
        @inbounds vbatch1 = view(batch1, :, :, i)
        @inbounds vbatch2 = view(batch2, :, :, i)
        BLAS.gemm!(tA, tB, alpha, vbatch1, vbatch2, one(T), result)
    end
    return result
end

bmm!(tA::Char, tB::Char, result::Array{T, 2}, batch1::Array{T, 3}, batch2::Array{T, 3}) where T =
    bmm!(tA, tB, result, one(T), batch1, batch2)
bmm(tA::Char, tB::Char, alpha::T, batch1::Array{T, 3}, batch2::Array{T, 3}) where T =
    bmm!(tA, tB, zeros(size(batch1, 1), size(batch2, 2)), alpha, batch1, batch2)
bmm(tA::Char, tB::Char, batch1::Array{T, 3}, batch2::Array{T, 3}) where T =
    bmm(tA, tB, one(T), batch1, batch2)

function addbmm!(tA::Char, tB::Char, result::Array{T, 2}, beta::T, mat::Array{T, 2}, alpha::T, batch1::Array{T, 3}, batch2::Array{T, 3}) where T
    bmm!(tA, tB, result, alpha, batch1, batch2)
    result += beta * mat
    return result
end

addbmm!(tA::Char, tB::Char, result::Array{T, 2}, mat::Array{T, 2}, batch1::Array{T, 3}, batch2::Array{T, 3}) where T =
    addbmm!(tA, tB, result, one(T), mat, one(T), batch1, batch2)

addbmm(tA::Char, tB::Char, beta::T, mat::Array{T, 2}, alpha::T, batch1::Array{T, 3}, batch2::Array{T, 3}) where T =
    addbmm!(tA, tB, zeros(size(batch1, 1), size(batch2, 2)), beta, mat, alpha, batch1, batch2)
addbmm(tA::Char, tB::Char, mat::Array{T, 2}, batch1::Array{T, 3}, batch2::Array{T, 3}) where T =
    addbmm!(tA, tB, one(T), mat, one(T), batch1, batch2)
