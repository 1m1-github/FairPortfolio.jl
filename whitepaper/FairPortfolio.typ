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
  abstract: "This paper describes a method of creating an stable, optimal portfolio based on an arbitrary list of assets. The model was practically tested vs other existing models and resulted in significantly better results (the test data is to be provided later or left as an exercise to the interested). The result is achieved via simplications of multiple types.",
  bibliography-file: "refs.bib",
)
#show link: underline
#set heading(level: 1, numbering: "I")
#set heading(level: 2, numbering: "I.1")

= Introduction

We assume that we have chosen a list of $n$ assets that we want to invest into. Us choosing these assets implies that we believe that each of these assets has a long term positive return.

The distribution of future returns of any asset consists of #link("https://en.wikipedia.org/wiki/Moment_(mathematics)")[moment]s of increasing degrees. The first degree moment is the expected return and is the hardest to predict. An investor should only choose assets that are believed to have positive first moment.

The second degree moments are the covariances between the assets, $sigma#sub[ij]$, including the variances of each asset $sigma#sub[ii]$. These covariances should be estimated by employing #link("https://en.wikipedia.org/wiki/Shrinkage_(statistics)")[shrinkage].

Moments of degree 3 and higher have very large errors in measurement and hence are completely ignored in this method. This is because financial data is highly noisy. This the first simplification (ignore rather than err).

= Homogeneous Variance

To get a stable portfolio, we first homogenize the variances across all assets and time 

$ sigma_(i i) = sigma $

An investor could choose any model to predict the variance of an asset for the following time period and pre-scale the asset such that all assets have approx. the same variance (or volatility) over any time period. One simple model to achieve that is to take the rolling window average variance.

= Minimal Variance Portfolio

Now that we have well estimated covariances, equal variances and we ignore moments of degree 1 and degrees 3 and higher, we find the optimal portfolio by minimizing the total portfolio variance.

With the symmetric covariance matrix $C$

$ C = mat(
  sigma, dots.h, sigma_(1n);
  dots.v, dots.down, dots.v;
  sigma_(1n), dots.h, sigma;
) $

the total portfolio variance $V$ is

$ V =  w^T dot.op C dot.op w = (w_1, ..., w_n) dot.op C dot.op mat(w_1;dots.v;w_n;)$

where $w$ are the weights of assets that we want to calculate.

We simplify algebraicly

$ V = w^T dot.op C dot.op w = (w_1, ..., w_n) dot.op mat(sigma, dots.h, sigma_(1n);dots.v, dots.down, dots.v;sigma_(1n), dots.h, sigma;) dot.op mat(w_1;dots.v;w_n;) $

$ = (sum_(i < n) w_i sigma_(1i) + w_n sigma_(1n), ..., sum_(i < n) w_i sigma_(n i) + w_n sigma_(n n)) mat(w_1;dots.v;w_n) $

$ = sum_(j < n) w_j sum_(i < n) w_i sigma_(j i) + w_n sum_(i < n) w_i sigma_(n 1) + sum_j w_j w_n sigma_(j n) $

$ = underbrace(sum_(i, j < n) w_i w_j sigma_(i j), A) + underbrace(2 sum_(j < n) w_j w_n sigma_(j n), B) + underbrace(w_n^2 sigma_(n n), C) $

To find the $w_k$ that minimizes $V$, we will solve for

$ frac(diff V, diff w_k) = 0 $

for all $k < n$.

This is equivalent (and slightly simpler) to solving

$ 0 = 1/2 dot.op frac(diff V, diff w_k) = 1/2 dot.op frac(diff (A+B+C), diff w_k) $

Also, we know that all the asset weights sum to 100%, i.e. we can reduce the problem by 1 dimension by realising (2nd simplification)

$ w_n = 1 - sum_(i < n) w_i $

which also means

$ frac(diff w_n, diff w_k) = -1 $

For $A$, we get

$ 1/2 dot.op frac(diff A, diff w_k) = sum_(i < n) w_i sigma_(k i) $

For $B$, we get

$ 1/2 dot.op frac(diff B, diff w_k) = sigma_(k n) frac(diff, diff w_k)(w_k w_n) + sum_(k eq.not j < n) w_j sigma_(j n) frac(diff w_n, diff w_k) $

$ = sigma_(k n) (w_n-w_k) - sum_(k eq.not j < n) w_j sigma_(j n) $

$ = sigma_(k n) - sigma_(k n) w_k - sigma_(k n) sum_(i < n) w_i - sum_(k eq.not j < n) w_j sigma_(j n) $

$ = sigma_(k n) - sigma_(k n) sum_(i < n) w_i - sum_(j < n) w_j sigma_(j n) $

$ = sigma_(k n) - sum_(i < n) w_i (sigma_(i n)+sigma_(k n)) $

For $C$, we get

$ 1/2 dot.op frac(diff C, diff w_k) = -w_n sigma_(n n) = -sigma_(n n) + sigma_(n n) sum_(i < n) w_i $

Putting it together, we get

$ 1/2 dot.op frac(diff V, diff w_k) = 1/2 dot.op frac(diff (A+B+C), diff w_k) $

$ = sigma_(k n)-sigma_(n n) + sum_(i < n) w_i(sigma_(n n)-sigma_(i n)-sigma_(k n)+sigma_(k i)) $

We can put previous formula into matrix form as follows

$ 0 = frac(diff V, diff w_k) arrow.l.r.double hat(S) hat(w) = hat(b) $
with

$ hat(w) = mat(w_1; dots.v; w_(n-1)) $

$ hat(b) = mat(sigma-sigma_(1n); dots.v; sigma-sigma_(n-1,n)) $

and $hat(S)$ the matrix containing $s_(i k)$ with

$ s_(i k) = sigma-sigma_(i n)-sigma_(k n)+sigma_(k i) = s_(k i) $

$ s_(i i) = 2(sigma - sigma_(i n)) $

// We can break up $hat(S)$ as follows

// $$\hat{S} = \tilde{C} + \tilde{C}^T + \sigma \cdot (I + \mathbb{1}) - (C_n + C_n^T)$$

// with $\tilde{C}$ the upper triangular covariance matrix

// $$\tilde{C} = ```\begin{pmatrix} 0 && \sigma_{12} && \sigma_{13} && \ldots && \sigma_{1,n-1} \\  && 0 && \sigma_{23} && \ldots && \sigma_{2,n-1} \\  &&  && \ddots && \ldots && \vdots \\ && \text{\huge0} && && 0 && \sigma_{n-1,n-1} \\ && && && && 0 \end{pmatrix}```$$

// $C_n$ the row repeating matrix

// $$C_n = ```\begin{pmatrix} \sigma_{1n} && \ldots && \sigma_{1n} \\ \vdots && \ddots && \vdots \\ \sigma_{n-1,n} && \dots && \sigma_{n-1,n} \\ \sigma && \ldots && \sigma\end{pmatrix}```$$

// $I$ the identity matrix

// $$I = ```\begin{pmatrix} 1 && && \text{\large0}\\ && \ddots \\ \text{\large0} && && 1\end{pmatrix}```$$

// and $\mathbb{1}$ the constant 1 matrix

// $$\mathbb{1} = ```\begin{pmatrix} 1 && \ldots && 1 \\ \vdots && \ddots && \vdots \\ 1 && \ldots && 1\end{pmatrix}```$$

Now we are left with solving a linear equation system

$ hat(S) hat(w) = hat(b) arrow.l.r.double hat(w)=hat(S) \\ hat(b) $

which gives us our optimal weights $w$.

= Conclusion

Separating the task of optimising the portfolio from homogenizing the variance of each asset across time and the different assets enables a significantly more stable portfolio. Using shrinkage to estimate the covariances also plays helps this stability.

Reducing the optimisation dimension helps further.

The described model was found to perform significantly better than other tested models in 2012. This data will be provided at some point and is left as an excercise for the interested reader until then.