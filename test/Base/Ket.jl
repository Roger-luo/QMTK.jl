using QMTK
using Compat.Test

lhs = rand(5); rhs = rand(5)
@test_throws TypeError dot(Ket(RHS, rhs), Ket(LHS, lhs))
@test dot(Ket(LHS, lhs), Ket(RHS, rhs)) == dot(lhs, rhs)
