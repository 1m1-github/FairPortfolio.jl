using Statistics, LinearAlgebra

# follow these steps to get a homogenized variance across assets and time
# 1. sample a covariance (or correlation) matrix from a large enough sample size
# 2. use large shrinkage on the covariance
# 3. calculate a running variance for each asset
# 4. rescale each asset in each time period (without looking forward) to have an approx homogeneous variance across assets and time

"""
    apply_f_from_2nd_row(prices::Matrix, f::Function, top_row_value)

Per column, apply function f to the prices row-by-row, depending on current and prev value
Good data from 2nd row.
"""
function apply_f_from_2nd_row(prices::Matrix, f::Function, top_row_value)
    (nrows, nassets) = size(prices)
    result = similar(prices)
    result[1, :] .= top_row_value # first time returns unknown, set to avoid NaN
    for rix in 2:nrows, cix in 1:nassets
        result[rix, cix] = f(prices[rix - 1, cix], prices[rix, cix])
    end
    result # first row contains no data
end
"""
    calc_lnret(prices::Matrix)

Input: prices
Output: continuous returns, good from 2nd row
https://en.wikipedia.org/wiki/Continuously_compounded_nominal_and_real_returns
"""
calc_lnret(prices::Matrix) = apply_f_from_2nd_row(prices, (prev, current) -> log(current/prev), 0)

"""
    calc_lnret(prices::Matrix)

Input: prices
Output: nominal returns, good from 2nd row
https://en.wikipedia.org/wiki/Continuously_compounded_nominal_and_real_returns
"""
calc_dret(prices::Matrix) = apply_f_from_2nd_row(prices, (prev, current) -> current/prev-1, 0)

"""
    calc_new_variance

Running variance calculation of time series data. Calculates the variance given the prev one, the prev point and the new point.
"""
calc_new_variance(prev_point, new_point, prev_mean, new_mean, prev_mod_var, window) = prev_mod_var + new_point^2 - prev_point^2 - window*(new_mean^2-prev_mean^2)

"""
    calc_running_variance(lnret::Matrix)

Output: Matrix of running variances with VAR_WINDOW.
Good data from 1+VAR_WINDOW ≤ nrows
"""
function calc_running_variance(lnret::Matrix)
    (nrows, nassets) = size(lnret)
    result = similar(lnret) # during loop contains variance*time

    first_meaningful_lnret_ix = 2
    first_meaningful_variance_ix = first_meaningful_lnret_ix + VAR_WINDOW
    first_range = first_meaningful_lnret_ix:first_meaningful_variance_ix - 1
    
    prev_point = lnret[first_meaningful_lnret_ix, :]
    prev_mean = mean(lnret[first_range, :], dims=1)
    result[first_meaningful_variance_ix - 1, :] = sum(lnret[first_range, :].^2, dims = 1) .- VAR_WINDOW * prev_mean.^2

    for cix in 1:nassets, rix in first_meaningful_variance_ix:nrows
        new_point = lnret[rix, cix]
        new_mean = prev_mean[cix] + (new_point - prev_point[cix]) / VAR_WINDOW
        
        prev_mod_var = result[rix - 1, cix]
        result[rix, cix] = calc_new_variance(prev_point[cix], new_point, prev_mean[cix], new_mean, prev_mod_var, VAR_WINDOW)

        prev_point[cix] = lnret[rix - VAR_WINDOW, cix]
        prev_mean[cix] = new_mean
        prev_mod_var = result[rix, cix]
    end

    result ./ (VAR_WINDOW - 1)
end

"""
    calc_running_homogenizer

Given running variance, calculates the homogenizing factor required to have a stable variance across assets and time (heteroskadasticity -> homoskadasticity).
Good data same as input.
"""
function calc_running_homogenizer(running_variance::Matrix)
    homogenous_variance_factor = TARGET_VARIANCE ./ running_variance
    truncated_homogenous_variance_factor = min.(MAX_VARIANCE, homogenous_variance_factor)
    truncated_homogenous_variance_factor[1+VAR_WINDOW:end, :] = sqrt.(truncated_homogenous_variance_factor[1+VAR_WINDOW:end, :])
    truncated_homogenous_variance_factor
end

"""
    shrink(C)

Statistical Shrinkage stabilizes the covariance matrix C
https://en.wikipedia.org/wiki/Shrinkage_(statistics)
"""
shrink(C::Matrix) = SHRINKAGE_FACTOR * C + (1.0 - SHRINKAGE_FACTOR)diagm(diag(C))

"""
    calc_norm_dret(dret::Matrix, running_var_homogenizer::Matrix)

Given the nominal returns (dret) and running variance homogenizer, calculate the homogenized nominal returns.
Good data from 1 rows after input
"""
function calc_norm_dret(dret::Matrix, running_var_homogenizer::Matrix)
    norm_dret = similar(dret)
    norm_dret[2:end, :] = dret[1:end-1, :].* running_var_homogenizer[1:end-1, :]
    norm_dret
end