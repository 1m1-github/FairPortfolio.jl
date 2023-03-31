using Test, Random, FairPortfolio

## for n=2, always expect w[i]=1/2
"""

"""
v = rand()*0.01
C = [v rand()*0.01; rand()*0.01 v]
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

function create_random_data(nrows = 1000, nassets = 3)
    asset_dret = randn(nrows-1, nassets)*0.2
    asset_prices = Matrix{Float64}(undef, nrows, nassets)
    asset_prices[1, :] = rand(nassets)*10
    for rix in 2:nrows, cix in 1:nassets
        asset_prices[rix, cix] = asset_prices[rix - 1, cix] * (1 + asset_dret[rix - 1, cix])
    end
    asset_prices
end