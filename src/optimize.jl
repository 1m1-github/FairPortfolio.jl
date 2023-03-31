include("utils.jl")
include("covariance.jl")

const VAR_WINDOW = 100 # how many data points to calculate variance
const TARGET_VARIANCE = (0.1/16)^2 # 10% standard deviation per annum if periods were daily; actually, it is just an arbitrary constant
const MAX_VARIANCE = 36
const SHRINKAGE_FACTOR = 0.1 # empirically found to work well

"""
    optimize(prices...)

Expects a vector per asset, rows are per time period.
Each asset has the same # of rows.
Calculates the homogenized and shrunk covariance matrix before running the core optimization.
Output: optimal weights per asset.
"""
optimize(prices::Tuple) = optimize(prices...)
function optimize(prices...)
    prices_matrix = tuple_to_matrix(prices...) # (nrows, nassets) = size(prices_matrix)
    lnret = calc_lnret(prices_matrix) # good data from 2 ≤ nrows
    running_var = calc_running_variance(lnret) # good data from 1 + VAR_WINDOW ≤ nrows
    running_var_homogenizer = calc_running_homogenizer(running_var) # good data from 1 + VAR_WINDOW ≤ nrows
    dret = calc_dret(prices_matrix) # good data from 2 ≤ nrows
    norm_dret = calc_norm_dret(dret, running_var_homogenizer) # good data from 2 + VAR_WINDOW ≤ nrows
    standard_covariance = cov(norm_dret[2 + VAR_WINDOW:end, :])
    shrunk_covariance = shrink(standard_covariance)
    covariance = create_constant_diagonals!(shrunk_covariance)
    
    cross_risk_weights = optimize(covariance)
    own_risk_weights = running_var_homogenizer[end, :]
    combined_weights = own_risk_weights .* cross_risk_weights
    shares = combined_weights ./ prices_matrix[end, :]

    explain(cross_risk_weights, own_risk_weights, combined_weights, shares)
    
    Dict(
        :cross_risk_weights => cross_risk_weights,
        :own_risk_weights => own_risk_weights,
        :combined_weights => combined_weights,
        :shares => shares,
    )
end

"""
    optimize(C)

(nassets, nassets) = size(C)
Takes a full (square) covariance matrix (C) (symmetric and positive semi-definite) and with constant diagonals.
Output: optimal weights per asset.
"""
function optimize(C::Matrix)
    n = size(C,1)
   
    if n == 1 return [1.0] end
   
    # k < n, i < n
    v, v_in, v_kn, v_ki = separate_cov_matrix(C)
    Ŝ = v .- v_in .- v_kn .+ v_ki
    b̂ = v .- v_in
   
    # solve linear equations
    ŵ = Ŝ \ b̂
   
    # truncate
    for i in 1:n-1
        0 ≤ ŵ[i] && continue
        ŵ[i] = 0 
    end

    # add nth dimension
    push!(ŵ, 1.0 - sum(ŵ))
   
    # normalize
    ŵ = ŵ ./ sum(ŵ)
   
    # code to check whether truncation is optimal
    # for i = 1:size(Index,1)
    #  if(2*CoVar(Index(i),m) >  CoVar(Index(i),Index(i)) + CoVar(m,m))
    #   disp('truncation to zero is not optimal');
    #  end
    # end
   
    ŵ
end