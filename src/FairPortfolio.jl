module FairPortfolio

export optimize

"""
This package implements the theory presented in the FairPortfolio white paper (https://github.com/1m1-github/FairPortfolio.jl/blob/main/README.md [working version]).
It is a portfolio optimization algorithm.

Given nassets of assets, with prices... being a tuple of prices vectors, one per asset.
All prices vectors need to have data for the same time periods (assumed one per row).

The algorithm provides a stable, optimized portfolio based on the following main ideas:
1. All risk can be categorized by it's degree (https://en.wikipedia.org/wiki/Moment_(mathematics))
2. First degree risk (expected value) is the hardest to predict. The user is expected to choose assets with positive first degree risk without any further assumptions or knowledge of timing or quantification of this risk.
3. Third and higher degree risks are extremely noisy to retrieve good information from.
4. Focus only on second degree risk = covariance
5. Minimize our risk (covariance) using the following ideas
6. Eliminate one dimension due to the restriction that all optimal weights sum to 1.
7. Homogenize the variance part of the covariance across all assets and time (without looking forward in time).
8. Solve analytically the reduced and simplified (constant diagonal) covariance matrix.

Before steps 6+7, we would have had, nassets^2/2 variables, after we reduce to ca. (nassets-2)^2/2 variables, making the optimization more stable.

Commonly used variable names:
rix: row index
cix: column index
six: start index
eix: end index
C: covariance matrix
v: variance
dret: discrete (nominal) return
lnret: log (continuous) return
"""

include("optimize.jl")

end