using Test, Random, FairPortfolio

## for n=2, always expect w[i]=1/2
C = [0.01 0.02; 0.02 0.01]
C = [1//100 2//100; 2//100 1//100]
w = optimize(C)
# @show w
@test w[1] == w[2] == 1//2

## random cases
COVAR_THRESHOLD = 0.05
for _ in 1:10 # random tests
    σ = rand() * COVAR_THRESHOLD
    typeof(σ)
    n = rand(1:20)
    C = Matrix{Float64}(undef,n,n)
    for i in 1:n, k in 1:n
        i == k && ( C[i,i] = σ ; continue )
        i < k && ( C[i,k] = rand() * COVAR_THRESHOLD ; continue )
        # k < i
        C[i, k] = C[k, i]
    end
    # @show C
    w = optimize(C)
    # @show w
    @test length(w) == n
    # @show sum(w)
    @test round(sum(w)) == 1.0
end