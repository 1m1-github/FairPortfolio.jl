module FairPortfolio

# https://github.com/1m1-github/FairPortfolio.jl/blob/main/README.md [working version]

export optimize

# important note
# this code is not providing a method to get a constant diagonal covariance matrix
# follow these steps to get one
# 1. sample a covariance (or correlation) matrix from a large enough sample size
# 2. use large shrinkage on the covariance
# 3. calculate a running variance for each asset
# 4. rescale each asset in each time period (without looking forward) to have an approx homogeneous variance across assets and time

# n assets
# C is covariance matrix (symmetric) with a constant diagonal of {assets}_i=1...n
function optimize(C)
 n = size(C,1)

 if n == 1 return [1.0] end

 σ, σ_in, σ_kn, σ_ki = separate_cov_matrix(C)
#  @show σ, σ_in, σ_kn, σ_ki
 Ŝ = σ .- σ_in .- σ_kn .+ σ_ki
#  @show Ŝ
 b̂ = σ .- σ_in
#  @show b̂

 # solve linear equations
 ŵ = Ŝ \ b̂
#  @show ŵ

 # add nth dimension
 push!(ŵ, 1.0 - sum(ŵ))
#  @show "add nth dimension", ŵ

 # truncate
 for i in 1:n-1
  0 ≤ ŵ[i] && continue
  ŵ[i] = 0 
 end
#  @show "truncate", ŵ

 # normalize
 ŵ = ŵ ./ sum(ŵ)
#  @show "normalize", ŵ

 # code to check whether truncation is optimal
 # for i = 1:size(Index,1)
 #  if(2*CoVar(Index(i),m) >  CoVar(Index(i),Index(i)) + CoVar(m,m))
 #   disp('truncation to zero is not optimal');
 #  end
 # end

 ŵ

end

function separate_cov_matrix(C)
    σ = C[end, end]
    σ_in = C[1:end-1, end]
    σ_kn = C[end, 1:end-1]'
    σ_ki = C[1:end-1, 1:end-1]

    σ, σ_in, σ_kn, σ_ki
end

end