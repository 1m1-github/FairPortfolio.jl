# <b><p align="center">FairPortfolio ~ a simple and stable optimal portfolio</p></b>
#### <p align="center">[email@1m1.io]</p>

<br></br>
## <p align="center">Publication</p>
The white paper can be found here: https://github.com/1m1-github/FairPortfolio.jl/blob/main/whitepaper/FairPortfolio.pdf

This pkg has been published as a julia library, available here: https://github.com/JuliaRegistries/General/tree/master/F/FairPortfolio  
This should also allow users to `add` the pkg in a julia runtime.

<br></br>
## <p align="center">Usage</p>

The main innovation is in the `optimize(C::Matrix)` method that takes a covariance matrix with a constant diagonal.

For convenience, the following method based on prices is also provided.

Choose n assets which you believe are going to increase in value over the long term.
For each asset, have a `prices` vector. The `prices` vectors for each asset should have equal `length`. The prices are denominated in a common ccy.

```
using FairPortfolio
optimize(prices_asset_1, prices_asset_2, prices_asset_3, ...)
```

The standard output displays the optimal weights your portfolio should use per asset.
E.g.
```
weights based on cross-risk:
0.33130302872447653,0.3320587287004601,0.33663824257506336

weights based on own-risk to get 3.906250000000001e-5 variance per time period (scale accordingly):
0.2303491927483238,0.2437090738769763,0.18799540576581383

weights based on combined risks: 0.0763153852217579,0.08092572524435526,0.06328644300918951

shares based on both risks and prices: 2.721552378761487e-6,4.513655979086473e-5,0.8497999937377919
```

- The first line describes the optimal weights considering only cross-risks (covariances) of the assets.

- The second line are the weights to have homogeneous own-risks (variances). If the input prices were e.g. per day, then these weights are to get a yearly standard deviation of 0.1.

- The third line is a multiplication of the first two lines. This is the final weighting.

- The fourth line is the number of shares you should hold per 1 ccy of funds.

>The above output is from the `example/crypto.jl` and tells us to hold approx 0.0000027 BTC, 0.000045 ETH, 0.85 DOGE in our portfolio to minimize our risk and have 10% annualized standard deviation (volatility) per 1 USD investment, given current data.
