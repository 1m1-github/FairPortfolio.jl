using Test, Random, FairPortfolio

"""
for nassets == 2, always expect w[i]=1/2
"""
function test_n2()
    v = rand()*0.01
    v_12 = rand()*0.01
    C = [v v_12; v_12 v]
    w = optimize(C)
    @test round(w[1], digits=1) == round(w[2], digits=1) == 0.5
end
test_n2()

"""
random covariance matrices
these are not positive semi-definite, but the code should still run
"""
function test_random_matrix()
    COVAR_THRESHOLD = 0.05
    for _ in 1:10 # random tests
        v = rand() * COVAR_THRESHOLD
        n = rand(102:200)
        C = Matrix{Float64}(undef,n,n)
        for i in 1:n, k in 1:n
            i == k && ( C[i,i] = v ; continue ) # constant variance (diagonal)
            i < k && ( C[i,k] = rand() * COVAR_THRESHOLD ; continue ) # random covariance
            # k < i
            C[i, k] = C[k, i] # symmetric
        end
        w = optimize(C)
        @test length(w) == n
        @test round(sum(w)) == 1.0
    end
end
test_random_matrix()

"""
create random prices and test that algorithm runs
"""
function create_random_data(nrows = 1000, nassets = 3)
    asset_dret = randn(nrows-1, nassets)*0.2
    asset_prices = Matrix{Float64}(undef, nrows, nassets)
    asset_prices[1, :] = rand(nassets)*10
    for rix in 2:nrows, cix in 1:nassets
        asset_prices[rix, cix] = asset_prices[rix - 1, cix] * exp(asset_dret[rix - 1, cix])
    end
    asset_prices
end
function test_random_prices()
    asset_prices = create_random_data()
    w = optimize(asset_prices[:, 1], asset_prices[:, 2], asset_prices[:, 3])
    @test length(w) == 3
    @test round(sum(w)) == 1.0
end
test_random_prices()