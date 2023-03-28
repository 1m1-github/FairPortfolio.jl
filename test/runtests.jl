using Test, FairPortfolio

## n=2 case, expect w[i]=1/2
C = [0.01 0.02; 0.02 0.01]
C = [1//100 2//100; 2//100 1//100]
w = FairPortfolio.optimize(C)
@show w
@test w[1] == w[2] == 1//2