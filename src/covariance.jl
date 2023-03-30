using Statistics, LinearAlgebra

## prepare input for testing
nassets = 3 # = ncols
nrows = 1000
asset_dret = randn(nrows-1, nassets)*0.2
asset_prices = Matrix{Float64}(undef, nrows, nassets)
asset_prices[1, :] = rand(nassets)*10
for rix in 2:nrows, cix in 1:nassets
    asset_prices[rix, cix] = asset_prices[rix - 1, cix] * (1 + asset_dret[rix - 1, cix])
end
typeof(asset_prices)
prices=asset_prices

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

# todo use sample variance instead of theoretical
calc_new_variance(prev_point, new_point, prev_mean, new_mean, prev_mod_var, window) = prev_mod_var + new_point^2 - prev_point^2 - window*(new_mean^2-prev_mean^2)
function calc_running_variance(lnret::Matrix, VAR_WINDOW=100)
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

calc_running_homogenizer(running_variance::Matrix, VAR_WINDOW=1, TARGET_VARIANCE=0.01, MAX_VARIANCE=36) = sqrt.(min.(MAX_VARIANCE, TARGET_VARIANCE ./ running_variance))

shrink(covariance::Matrix, SHRINKAGE_FACTOR = 0.1) = SHRINKAGE_FACTOR * covariance + (1.0 - SHRINKAGE_FACTOR)diagm(diag(covariance))
calc_cov_matrix(norm_dret::Matrix) = shrink(cov(norm_dret))

function calc_norm_dret(dret::Matrix, running_var_homogenizer::Matrix)
    norm_dret = similar(dret)
    norm_dret[2:end, :] = dret[1:end-1, :].* running_var_homogenizer[1:end-1, :]
    norm_dret
end

# reduce heteroskadasticity

## run
prices=asset_prices
lnret = calc_lnret(prices)
running_var = calc_running_variance(lnret)
running_var_homogenizer = calc_running_homogenizer(running_var)
dret = calc_dret(prices)
norm_dret = calc_norm_dret(dret, running_var_homogenizer)
running_var_after_norm = calc_running_variance(norm_dret[100:end, :])

using Plots
bar(dret[100:end,1])
bar(norm_dret[100:end,1])
bar(1:length(dret[100:end,1]),[dret[100:end,1] norm_dret[100:end,1]])
1:length(dret[100:end,1])

covariance = calc_cov_matrix(norm_dret[100:end, :])
optimize(covariance)




plot(running_var_homogenizer[200:end,1])
bar((norm_dret ./ dret)[200:end,1])




g=20
running_var[end-g:end, :]
running_var_after_norm[end-g:end, :]

@show running_var[end,:]

var(lnret[end-100+1:end,1])

x=lnret[1:100,1]
file=open("./a.csv", "w")
s=join(map(y->round(y,digits=5), x), "\n")
write(file, s)
close(file)

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