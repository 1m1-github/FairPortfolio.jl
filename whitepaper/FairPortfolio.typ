// todo
// add .jl ref
// add simplications

// typst compile whitepaper/FairPortfolio.typ whitepaper/FairPortfolio.pdf
#import "template.typ": *
#show: ams-article.with(
  title: "FairPortfolio ~ a simple and stable optimal portfolio",
  authors: (
    (
      name: "1m1",
      email: "email@1m1.io",
    ),
  ),
  abstract: "This paper describes a method of creating a stable and optimal portfolio based on an arbitrary list of assets. The method employs multiple simplifications that lead to numerical and qualitative stability of the portfolio.",
  bibliography-file: "refs.bib",
)
#show link: underline
// #set heading(level: 1, numbering: "I")
// #set heading(level: 1, numbering: "")
// #set math.equation(numbering: "(1)")

= *Introduction*
\ \
Portfolio optimization is about finding weights for each asset that one wants to include in a portfolio.
One of the longest standing theoretical results in this field is due to Markowitz@markowitz, which minimizes the portfolio variance using the expected return and variance of each asset.
\ \  
In this paper, we are also ultimately going to minimize portfolio risk after applying the following 3 simplifications:

- consider only 2nd moments (@simplification_1[simplification])
- homogenize variances (@simplification_2[simplification])
- algebraically reduce dimension (@simplification_3[simplification])
\
We assume that we have chosen a list of $n$ assets that we want to invest into. Us choosing these assets implies that we believe that each of these assets has a long term positive return.

#set math.equation(numbering: none)
#set heading(level: 1, numbering: "1")

\ \
= *Only 2nd Moments* <simplification_1>
\ \
The distribution of returns of any asset can be fully described using #link("https://en.wikipedia.org/wiki/Moment_(mathematics)")[moment]s.
\ \
The 1st moment is the expected return and is the hardest to predict. An investor should only choose assets that are believed to have positive 1st moment.
\ \
The 2nd moments are the #link(<stable-covariances>)[covariances] between the assets, $sigma_(i j)$, including the variances of each asset $sigma_(i i)$.
\ \
Moments of degree 3-and-  higher have ever larger relative errors of measurement due to financial data being highly noisy.
\ \
For numerical and qualitative stability, we should not include high error parameters in our optimization.
This leaves us only with 2nd moments.
\ \
= *Homogeneous variances* <simplification_2>
\ \
To further stablilize our portfolio, we homogenize the variances across all assets and time:

$ sigma_(i i)(t) = sigma $

An investor could choose any model to predict the variance of an asset for the following time period and pre-scale the asset such that all assets have approx. the same variance (or volatility) over any time period. One simple model to achieve that is to take the rolling window average variance, which works quite well.
\ \
This reduces our parameter space to the cross-variances, $sigma_(i j)$ with $i eq.not j$
\ \
= *Algebraically reduce dimension* <simplification_3>
\ \
Since all the weights of the portfolio sum to 1, we can reduce one dimension as follows:

$ w_n = 1 - sum_(i < n) w_i $

This is not a statistical reduction of dimension, rather an algebraic one. This guarantees increase in optimization stability by removing $n-1$ parameters $sigma_(i n)$ with $i<n$.

#set heading(level: 1, numbering: none)

\ \
= *Minimal Variance Portfolio*
\ \
Using @simplification_1[simplication], our portfolio risk is equal to the portfolio variance $V$

$ V =  w^T dot.op C dot.op w = (w_1 dots.h w_n) dot.op C dot.op mat(w_1; dots.v; w_n;) $

with $w$ being the asset weights and $C$ being the covariance matrix, which thanks to @simplification_2[simplication], looks as follows

$ C = mat(
  sigma, dots.h, sigma_(1n);
  dots.v, dots.down, dots.v;
  sigma_(1n), dots.h, sigma;
) $
We simplify algebraically

$ V = (w_1 dots.h w_n) dot.op mat(sigma, dots.h, sigma_(1n);dots.v, dots.down, dots.v;sigma_(1n), dots.h, sigma;) dot.op mat(w_1;dots.v;w_n;) $

$ = (sum_(i < n) w_i sigma_(1i) + w_n sigma_(1n) dots.h sum_(i < n) w_i sigma_(n i) + w_n sigma_(n n)) dot.op mat(w_1;dots.v;w_n) $

$ = sum_(j < n) w_j sum_(i < n) w_i sigma_(j i) + w_n sum_(i < n) w_i sigma_(n 1) + sum_j w_j w_n sigma_(j n) $

$ = underbrace(sum_(i, j < n) w_i w_j sigma_(i j), A) + underbrace(2 sum_(j < n) w_j w_n sigma_(j n), B) + underbrace(w_n^2 sigma_(n n), C) $
\ \
To find the $w_k$ that minimizes $V$, we will solve for

$ frac(diff V, diff w_k) = 0 $

for all $k < n$. This is equivalent (and slightly simpler) to solving

$ 0 = 1/2 dot.op frac(diff V, diff w_k) = 1/2 dot.op frac(diff (A+B+C), diff w_k) $
\
Using @simplification_3[simplication] and $frac(diff w_n, diff w_k)=-1$ for $k<n$, we get:
\ \
For $A$

$ 1/2 dot.op frac(diff A, diff w_k) = sum_(i < n) w_i sigma_(k i) $

For $B$

$ 1/2 dot.op frac(diff B, diff w_k) = sigma_(k n) frac(diff, diff w_k)(w_k w_n) + sum_(k eq.not j < n) w_j sigma_(j n) frac(diff w_n, diff w_k) $

$ = sigma_(k n) (w_n-w_k) - sum_(k eq.not j < n) w_j sigma_(j n) $

$ = sigma_(k n) - sigma_(k n) w_k - sigma_(k n) sum_(i < n) w_i - sum_(k eq.not j < n) w_j sigma_(j n) $

$ = sigma_(k n) - sigma_(k n) sum_(i < n) w_i - sum_(j < n) w_j sigma_(j n) $

$ = sigma_(k n) - sum_(i < n) w_i (sigma_(i n)+sigma_(k n)) $

For $C$

$ 1/2 dot.op frac(diff C, diff w_k) = -w_n sigma_(n n) = -sigma_(n n) + sigma_(n n) sum_(i < n) w_i $
\
Putting it together, we get

$ 1/2 dot.op frac(diff V, diff w_k) = 1/2 dot.op frac(diff (A+B+C), diff w_k) $

$ = sigma_(k n)-sigma_(n n) + sum_(i < n) w_i(sigma_(n n)-sigma_(i n)-sigma_(k n)+sigma_(k i)) $
\
We can put previous formula into matrix form as follows

$ 0 = frac(diff V, diff w_k) arrow.l.r.double hat(S) hat(w) = hat(b) $
with

$ hat(w) = mat(w_1; dots.v; w_(n-1)) $

$ hat(b) = mat(sigma-sigma_(1n); dots.v; sigma-sigma_(n-1,n)) $

and $hat(S)$ the matrix containing $hat(s)_(i k)$ with $i eq.not k$
\
$ hat(s)_(i k) = sigma-sigma_(i n)-sigma_(k n)+sigma_(k i) = hat(s)_(k i) $

$ hat(s)_(i i) = 2(sigma - sigma_(i n)) $
\
Now we are left with solving a linear equation system
\ \
$ hat(S) hat(w) = hat(b) arrow.l.r.double hat(w)=hat(S) \\ hat(b) $
\
which gives us our optimal weights $w$.

\ \
= *Conclusion*
\ \
Targeting portfolio risk minization whilst only considering numerically stable parameters and reducing variables as mathematically possible leads to a stable and optimal portfolio.
\ \
#link(<performance>)[Performance] is improved by the gain in stability vs the loss of information by disregarding highly noisy parameters (e.g. moments of degree 1 and 3-and-higher).
\ \
This method was tested practically on multiple common trading strategies (e.g. trend following) vs. what were considered the 10 top portfolio optimization methods in 2012. This model presented significantly better historical performance whilst being simpler. The test data is not presented in this paper. This model has been since used to manage several large portfolios.

\ \
= *Notes*
\ \
*stable covariance* <stable-covariances>
To get a stable covariance matrix, one should use returns over multiple time periods (e.g. if daily data is available, use 10 day rolling returns).
Additionally, use #link("https://en.wikipedia.org/wiki/Shrinkage_(statistics)")[shrinkage] to stabilize the covariance:
$ C_("shrunk") = alpha dot.op C + (1-alpha) dot.op "diagm"("diag"(C)) $
where $"diagm"("diag"(C))$ is the matrix with zeros off-diagonal and the same diagonal as $C$. $alpha=0.1$ has worked well in the author's experience.
\ \
*performance* <performance>
Performace of investment strategies is, in the author's experience, best measured using #link("https://en.wikipedia.org/wiki/Omega_ratio")[Omega].
\ \ \