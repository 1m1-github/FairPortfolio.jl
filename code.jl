using LinearAlgebra
using Symbolics

I = Diagonal(ones(Num, 3))
ONE = ones(Num, 3, 3)

@variables s, s12, s13, s23

Ĉ_tmp = [0 s12 s13
0 0 s23
0 0 0]
Ĉ = Ĉ_tmp + Ĉ_tmp'
C = s * I + Ĉ

C_n = repeat(C[end, :], 1, 3)

Â = C + s * ONE - C_n - C_n'
A = Â[1:end-1, 1:end-1]

A^(-1)

@variables z1, z2, z3
z = [z1, z2]

simplify.(z' * A * z)
