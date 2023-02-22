using LinearAlgebra
using Symbolics

n=2

I = Diagonal(ones(Num, n))
ONE = ones(Num, n, n)

@variables C[1:n, 1:n]

Ĉ_tmp = zeros(Num, n, n)
for i in 1:n, j in 1:n
    j <= i && continue
    Ĉ_tmp[i, j] = C[i, j]
end

σ = C[1, 1]

Ĉ = Ĉ_tmp + Ĉ_tmp'
C = σ * I + Ĉ

C_n = repeat(C[end, :], 1, n)

S = C + σ * ONE - C_n - C_n'
S̃ = S[1:end-1, 1:end-1]

S̃
S̃^(-1)

simplify(det(S̃))

Ĉ_tmp
Ĉ_tmp+Ĉ_tmp'
det(Ĉ_tmp)
det(Ĉ_tmp')
det(Ĉ_tmp+Ĉ_tmp') # Ĉ

det(σ*I + Ĉ) # C

det(C_n)
det(C_n')
det(C_n+C_n')

det(σ*ONE)
det(σ*I)
det(σ*(I + ONE))

det(Ĉ + σ*(I + ONE))

det(Ĉ[1:end-1,1:end-1])
det((σ*(I + ONE))[1:end-1,1:end-1])
det((C_n + C_n')[1:end-1,1:end-1])

det(Ĉ_tmp + Ĉ_tmp' - (C_n + C_n'))

X = Ĉ + σ*(I + ONE) - (C_n + C_n')
X = X[1:end-1, 1:end-1]
det(X)

@variables a, b, c, d
subs = Dict(C[1, 1] => 1.0)
for i in 1:n-1
    subs[C[i, n]] = i+1
    subs[C[i, n]] = 10*rand()
end
substitute(-det(C_n+C_n'),subs)

@variables a, b, c, d, e,f

substitute(-det((C_n + C_n')[1:end-1,1:end-1]),Dict(C[1,1]=>1,C[1,2]=>a))
substitute(-det((C_n + C_n')[1:end-1,1:end-1]),Dict(C[1,1]=>1,C[1,3]=>a,C[2,3]=>b))
substitute(-det((C_n + C_n')[1:end-1,1:end-1]),Dict(C[1,1]=>1,C[1,4]=>a,C[2,4]=>b,C[3,4]=>c))

substitute(det(Ĉ[1:end-1,1:end-1]), Dict(C[1,1]=>1,C[1,4]=>a,C[2,4]=>b,C[3,4]=>c,C[1,3]=>d,C[2,3]=>e,C[1,2]=>f))

substitute(det(Ĉ_tmp+Ĉ_tmp'), Dict(C[1,1]=>1,C[1,4]=>a,C[2,4]=>b,C[3,4]=>c,C[1,3]=>d,C[2,3]=>e,C[1,2]=>f))