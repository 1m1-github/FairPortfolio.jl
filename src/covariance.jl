using Statistics

## prepare input for testing
nassets = 3 # = ncols
nrows = 1000
asset_dret = randn(nrows-1, nassets)*0.1
asset_prices = Matrix{Float64}(undef, nrows, nassets)
asset_prices[1, :] = rand(nassets)*10
for rix in 2:nrows, cix in 1:nassets
    asset_prices[rix, cix] = asset_prices[rix - 1, cix] * (1 + asset_dret[rix - 1, cix])
end

typeof(asset_prices)


function apply_f_from_2nd_row(prices::Matrix, f::Function, top_row_value)
    (nrows, nassets) = size(prices)
    result = similar(prices)
    result[1, :] .= top_row_value # first time returns unknown, set to avoid NaN
    for rix in 2:nrows, cix in 1:nassets
        result[rix, cix] = f(asset_prices[rix, cix], asset_prices[rix - 1, cix])
    end
    result # first row contains no data
end
calc_lnret(prices::Matrix) = apply_f_from_2nd_row(prices, (prev, current) -> log(current/prev), 0)
calc_dret(prices::Matrix) = apply_f_from_2nd_row(prices, (prev, current) -> current/prev-1, 0)

calc_new_variance(prev_point, new_point, prev_mean, new_mean, prev_mod_var, window) = prev_mod_var + new_point^2 - prev_point^2 - window*(new_mean^2-prev_mean^2)
function calc_running_variance(lnret::Matrix, VAR_WINDOW=100)
    (nrows, nassets) = size(prices)
    result = similar(lnret)

    first_meaningful_lnret_ix = 2
    first_meaningful_variance_ix = first_meaningful_lnret_ix + VAR_WINDOW
    first_range = first_meaningful_lnret_ix:first_meaningful_variance_ix - 1

    new_mean = mean(lnret[first_range, :])
    result[first_meaningful_variance_ix - 1, :] .= sum(lnret[first_range, :].^2)- VAR_WINDOW * new_mean^2

    for cix in 1:nassets, rix in first_meaningful_variance_ix:nrows
        prev_point = lnret[rix - VAR_WINDOW, cix]
        new_point = lnret[rix, cix]
        prev_mean = mean(lnret[rix - VAR_WINDOW:rix - 1])
        new_mean = prev_mean + (new_point - prev_point) / VAR_WINDOW
        prev_mod_var = result[rix - 1, cix]
        result[rix, cix] = new_variance(prev_point, new_point, prev_mean, new_mean, prev_mod_var, VAR_WINDOW)
    end
    result
end

## run
prices=asset_prices
lnret = calc_lnret(prices)


## old
window = bb_constants.STD_WINDOW
ret = d.data["lnret_close"]
prev_point = ret[rix-window,cix]
new_point = ret[rix,cix]
prev_mean = mean(ret[rix-window:rix-1])
new_mean = prev_mean + (new_point-prev_point)/window
prev_mod_var = (window-1)*(d.data["std"][rix-1,cix]/16.0)^2.0
new_mod_var = bb_stats.new_variance(prev_point,new_point,prev_mean,new_mean,prev_mod_var,window)
sqrt_argument = new_mod_var/(window-1)
if sqrt_argument ≤ 0.0
    # sqrt_argument ≤ 0.0 && ( sqrt_argument = 0.0 )
    @notify("$(d.cols[cix]) has std 0 for $(d.rows[rix])")
    d.data["std"][rix,cix] = d.data["std"][rix-1,cix]
else
    d.data["std"][rix,cix] = sqrt(sqrt_argument)*16
end
end