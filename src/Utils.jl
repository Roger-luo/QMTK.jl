export kronprod, ⊗

⊗(A, B) = kron(A, B)

function kronprod(itr)
    state = start(itr)
    first, state = next(itr, state)
    second, state = next(itr, state)
    pd = kron(first, second)
    while !done(itr, state)
        val, state = next(itr, state)
        pd = kron(pd, val)
    end
    return pd
end

kronprod(m::SparseMatrixCSC...) = kronprod(m)
