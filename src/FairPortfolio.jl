module FairPortfolio

# https://github.com/1m1-github/FairPortfolio.jl/blob/main/README.md [working version]

export optimize

# follow these steps to get one
# 1. sample a covariance (or correlation) matrix from a large enough sample size
# 2. use large shrinkage on the covariance
# 3. calculate a running variance for each asset
# 4. rescale each asset in each time period (without looking forward) to have an approx homogeneous variance across assets and time

include("optimize.jl")

end