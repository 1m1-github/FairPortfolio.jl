# <b><p align="center">sleepbetter ~ a simple and stable optimal portfolio</p></b>
#### <p align="center">[email@1m1.io](https://github.com/2i2i/whitepaper/blob/main/Notes.md#acknowledgement)</p>

<br></br>
## <p align="center">Abstract</p>
<p align="center">This <a href="https://github.com/2i2i/whitepaper/blob/main/Notes.md#whitepaper">whitepaper</a> describes a method of creating an stable, optimal portfolio based on arbitrary list of assets. </p>
<br></br>

# <b>I. Introduction</b>

We assume that we have chosen a list of $n$ assets that we want to invest into. Us choosing these assets implies that we believe that each of these assets has a long term positive return.

The distribution of future returns of any asset consists of <a href=https://en.wikipedia.org/wiki/Moment_(mathematics)>*moment*s</a> of increasing degrees. The first degree *moment* is the expected value and is the hardest to predict. An investor should only choose assets that are believed to have positive first *moment*.

The second degree *moment*s are the covariances between the assets, $\sigma_{ij}$, including the variances of each asset $\sigma_{ii}$. These covariances should be estimated by employing <a>shrinkage</a>.

Third degree moments are referred to as skewness and fourth degree moments as kurtosis. However, moments of degree 3 and higher have very large errors in measurement and hence are completely ignored in this method. This is because financial data is highly noisy.

<br></br>
# <b>II. Homogeneous Variance</b>

To get a stable portfolio, we first homogenize the variances of all assets

$$\sigma_{ii} = \sigma$$

An investor could choose any model to predict the variance of an asset for the following time period and pre-scale the asset such that all assets have approx. the same variance (or volatility) over any time period. One simple model to achieve that is described <a>here</a>.

<br></br>
# <b>III. Minimal Variance Portfolio</b>

Now that we have well estimated covariances, equal variances and we ignore moments of degree 1 and degrees 3 and higher, we find the optimal portfolio by minimizing the total portfolio variance.

With the symmetric covariance matrix $C$
$$C = \begin{pmatrix} \sigma & \ldots &\sigma_{1n} \\ \vdots & \ddots & \vdots \\ \sigma_{1n} & \ldots &\sigma \end{pmatrix}$$

the total portfolio variance $V$ is
$$V = w^T\cdot C \cdot w = (w_1, \ldots, w_n) C \begin{pmatrix} w_1 \\ \vdots \\ w_n \end{pmatrix}$$
where $w$ are the weights of assets that we want to calculate.

We simplify algebraicly
$$V = w^T\cdot C \cdot w = (w_1, \ldots, w_n) \begin{pmatrix} \sigma_{11} & \ldots &\sigma_{n1} \\ \vdots & \ddots & \vdots \\ \sigma_{1n} & \ldots &\sigma_{nn} \end{pmatrix} \begin{pmatrix} w_1 \\ \vdots \\ w_n \end{pmatrix}$$

$$= (\sum_{i < n} w_i \sigma_{1i} + w_n \sigma_{1n}, \ldots, \sum_{i < n} w_i \sigma_{ni} + w_n \sigma_{nn}) \begin{pmatrix} w_1 \\ \vdots \\ w_n \end{pmatrix}$$

$$= \sum_{j < n} w_j \sum_{i < n} w_i \sigma_{ji} + w_n \sum_{i < n} w_i \sigma_{n1} + \sum_j w_j w_n \sigma_{jn}$$

$$= \underbrace{\sum_{i, j < n} w_i w_j \sigma_{ij}}_A + \underbrace{2 \sum_{j < n} w_j w_n \sigma_{jn}}_B + \underbrace{w_n^2 \sigma_{nn}}_C$$

To find the $w_k$ that minimizes $V$, we will solve for
$$\frac{\partial{V}}{\partial{w_k}} = 0$$
for all $k<n$.

This is equivalent (and slightly simpler) to solving
$$0 = \frac{1}{2} \cdot \frac{\partial{V}}{\partial{w_k}}= \frac{1}{2} \cdot \frac{\partial{(A+B+C)}}{\partial{w_k}}$$

Also, we know that all the asset weights sum to 100%, i.e. we can reduce the problem by 1 dimension by realising
$$ w_n = 1 - \sum_{i<n} w_i $$
which also means
$$\frac{\partial{w_n}}{\partial{w_k}} = -1$$

For $A$, we get
$$\frac{1}{2} \cdot \frac{\partial{A}}{\partial{w_k}} = \sum_{i<n} w_i \sigma_{ki}$$

For $B$, we get
$$\frac{1}{2} \cdot \frac{\partial{B}}{\partial{w_k}} = \sigma_{kn}\frac{\partial{}}{\partial{w_k}}(w_kw_n) + \sum_{k \ne j < n} w_j \sigma_{jn} \frac{\partial{w_n}}{\partial{w_k}}$$

$$= \sigma_{kn} (w_n-w_k) - \sum_{k \ne j < n} w_j \sigma_{jn}$$

$$= \sigma_{kn} - \sigma_{kn} w_k - \sigma_{kn}\sum_{i<n}w_i - \sum_{k \ne j < n} w_j \sigma_{jn}$$

$$= \sigma_{kn} - \sigma_{kn}\sum_{i<n}w_i - \sum_{j < n} w_j \sigma_{jn}$$

$$= \sigma_{kn} - \sum_{i<n} w_i (\sigma_{in}+\sigma_{kn})$$

For $C$, we get
$$\frac{1}{2} \cdot \frac{\partial{C}}{\partial{w_k}} = -w_n\sigma_{nn} = -\sigma_{nn} + \sigma_{nn}\sum_{i<n} w_i$$

Putting it together, we get
$$\frac{1}{2} \cdot  \frac{\partial{V}}{\partial{w_k}} =\frac{1}{2} \cdot \frac{\partial{(A+B+C)}}{\partial{w_k}}$$
$$ = \sigma_{kn}-\sigma_{nn} + \sum_{i < n} w_i(\sigma_{nn}-\sigma_{in}-\sigma_{kn}+\sigma_{ki})$$

We can put previous formula into matrix form as follows
$$0 = \frac{\partial{V}}{\partial{w_k}} \Leftrightarrow \hat{S} \hat{w} = \hat{b}$$
with
$$\hat{w} = \begin{pmatrix} w_1 \\ \vdots \\ w_{n-1} \end{pmatrix}$$
$$\hat{b} = \begin{pmatrix} \sigma_{1n}-\sigma \\ \vdots \\ \sigma_{n-1,n}-\sigma \end{pmatrix}$$
$$\hat{S}=\text{matrix containing }s_{ik}$$
$$s_{ik} = \sigma-\sigma_{in}-\sigma_{kn}+\sigma_{ki} = s_{ki}$$
$$s_{ii} = 2(\sigma - \sigma_{in})$$

We can break up $\hat{S}$ as follows
$$\hat{S} = \tilde{C} + \tilde{C}^T + \sigma \cdot (I + \mathbb{1}) - (C_n + C_n^T)$$

with
$$\hat{C} = C[1:end-1][1:end-1] = \begin{pmatrix} \sigma & \ldots &\sigma_{1,n-1} \\ \vdots & \ddots & \vdots \\ \sigma_{1,n-1} & \ldots &\sigma \end{pmatrix}$$

$$C_n = \begin{pmatrix} \sigma_{1n} && \ldots && \sigma_{1n} \\ \vdots && \ddots && \vdots \\ \sigma_{n-1,n} && \dots && \sigma_{n-1,n} \\ \sigma && \ldots && \sigma\end{pmatrix}$$

$$\tilde{C} = \begin{pmatrix} 0 && \sigma_{12} && \sigma_{13} && \ldots && \sigma_{1,n-1} \\  && 0 && \sigma_{23} && \ldots && \sigma_{2,n-1} \\  &&  && \ddots && \ldots && \vdots \\ && \text{\huge0} && && 0 && \sigma_{n-1,n-1} \\ && && && && 0 \end{pmatrix}$$




$$\hat{S} \hat{w} = \hat{b} \Leftrightarrow \hat{w}=\hat{S} \backslash \hat{b}$$

Given $n$ assets