"""
    explain(weights, running_var_homogenizer, prices_matrix)

User friendly results.
"""
function explain(weights, running_var_homogenizer, prices_matrix)
    cross_risk_weights = weights
    println("weights based on cross-risk: ", join(cross_risk_weights, ','))
    
    own_risk_weights = running_var_homogenizer[end, :]
    println("weights based on own-risk to get 0.01 : ", join(own_risk_weights, ','))

    both_weights = own_risk_weights .* cross_risk_weights
    println("weights based on both risks: ", join(both_weights, ','))

    shares = both_weights ./ prices_matrix[end, :]
    println("shares based on both risks and prices: ", join(shares, ','))
end

"""
    tuple_to_matrix(prices::Tuple)

Input are prices vectors per asset as a tuple or separated as arguments.
E.g. tuple_to_matrix(asset_1_prices, asset_2_prices, asset_3_prices, ...)
Returns a Matrix with a column per asset and a row per time period.
"""
tuple_to_matrix(prices::Tuple) = tuple_to_matrix(prices...)
function tuple_to_matrix(prices...)
    nassets = length(prices)
    nrows = length(prices[1])
    m = Matrix{eltype(prices[1][1])}(undef, nrows, nassets)
    for cix in 1:nassets
        @assert(length(prices[cix]) == nrows) # same amount of data for each asset needed
        m[:, cix] = prices[cix]
    end
    m
end

"""
    create_constant_diagonals!(C)

Takes a 
Assets that C is square and replaces it's diagonal with the mean of it's diagonal
"""
function create_constant_diagonals!(C::Matrix)
    (n, m) = size(C)
    @assert(n == m)
    v = mean(diag(C))
    for i in 1:n
        C[i, i] = v
    end
    C
end

"""
    separate_cov_matrix(C)

(nassets, nassets) = size(C)
Takes a full (square) covariance matrix (C) (symmetric and positive semi-definite) and with constant diagonals.
Returns C split into four parts as required by the optimization.
"""
function separate_cov_matrix(C)
    v = C[end, end]
    v_in = C[1:end-1, end]
    
    v_kn = C[end, 1:end-1]'
    v_ki = C[1:end-1, 1:end-1]

    v, v_in, v_kn, v_ki
end
