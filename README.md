# <b><p align="center">bettersleep ~ a simple and stable optimal portfolio</p></b>
#### <p align="center">[1m1@2i2i.app](https://github.com/2i2i/whitepaper/blob/main/Notes.md#acknowledgement)</p>

<br></br>
## <p align="center">Abstract</p>
<p align="center">This <a href="https://github.com/2i2i/whitepaper/blob/main/Notes.md#whitepaper">whitepaper</a> describes a method of creating an </p>
<br></br>

# <b>I. Definitions</b>



<br></br>
## Market
# optimal_portfolio
A simplification of portfolio optimization that leads to better results

$$C = \begin{pmatrix} \sigma_{11} & \ldots &\sigma_{n1} \\ \vdots & \ddots & \vdots \\ \sigma_{1n} & \ldots &\sigma_{nn} \end{pmatrix}$$

$$C = \begin{pmatrix} \sigma & \ldots &\sigma_{1n} \\ \vdots & \ddots & \vdots \\ \sigma_{1n} & \ldots &\sigma \end{pmatrix}$$

$$w^T\cdot C \cdot w = (w_1, \ldots, w_n) C \begin{pmatrix} w_1 \\ \vdots \\ w_n \end{pmatrix}$$

$$w^T\cdot C \cdot w = (w_1, \ldots, w_n) \begin{pmatrix} \sigma_{11} & \ldots &\sigma_{n1} \\ \vdots & \ddots & \vdots \\ \sigma_{1n} & \ldots &\sigma_{nn} \end{pmatrix} \begin{pmatrix} w_1 \\ \vdots \\ w_n \end{pmatrix}$$

$$= (\sum_{i < n} w_i \sigma_{1i} + w_n \sigma_{1n}, \ldots, \sum_{i < n} w_i \sigma_{ni} + w_n \sigma_{nn}) \begin{pmatrix} w_1 \\ \vdots \\ w_n \end{pmatrix}$$

$$= \sum_{j < n} w_j \sum_{i < n} w_i \sigma_{ji} + w_n \sum_{i < n} w_i \sigma_{n1} + \sum_j w_j w_n \sigma_{jn}$$

$$= \underbrace{\sum_{i, j < n} w_i w_j \sigma_{ij}}_A + \underbrace{2 \sum_{j < n} w_j w_n \sigma_{jn}}_B + \underbrace{w_n^2 \sigma_{nn}}_C$$

$$\sigma_{ij} = \sigma_{ji}$$

$$\sigma = \sigma_{ii}$$


$$ w_n = 1 - \sum_{i<n} w_i $$


$$\frac{\partial{}}{\partial{w_k}}, k < n$$

$$\frac{\partial{w_n}}{\partial{w_k}} = -1$$

$$\frac{1}{2} \cdot \frac{\partial{B}}{\partial{w_k}} = \sigma_{kn}\frac{\partial{}}{\partial{w_k}}(w_kw_n) + \sum_{k \ne j < n} w_j \sigma_{jn} \frac{\partial{w_n}}{\partial{w_k}}$$

$$= \sigma_{kn} (w_n-w_k) - \sum_{k \ne j < n} w_j \sigma_{jn}$$

$$= \sigma_{kn} - \sigma_{kn} w_k - \sigma_{kn}\sum_{i<n}w_i - \sum_{k \ne j < n} w_j \sigma_{jn}$$

$$= \sigma_{kn} - \sigma_{kn}\sum_{i<n}w_i - \sum_{j < n} w_j \sigma_{jn}$$

$$= \sigma_{kn} - \sum_{i<n} w_i (\sigma_{in}+\sigma_{kn})$$

$$\frac{1}{2} \cdot \frac{\partial{C}}{\partial{w_k}} = -w_n\sigma_{nn} = -\sigma_{nn} + \sigma_{nn}\sum_{i<n} w_i$$

$$\frac{1}{2} \cdot \frac{\partial{(B+C)}}{\partial{w_k}} = \sigma_{kn}-\sigma_{nn} - \sum_{i < n} w_i(\sigma_{in}+\sigma_{kn}-\sigma_{nn})$$

$$\frac{1}{2} \cdot \frac{\partial{A}}{\partial{w_k}} = \sum_{i<n} w_i \sigma_{ki}$$

$$\forall k<n: 0 = \frac{1}{2} \cdot  \frac{\partial{(w^T\cdot C \cdot w)}}{\partial{w_k}} =\frac{1}{2} \cdot \frac{\partial{(A+B+C)}}{\partial{w_k}}$$
$$ = \sigma_{kn}-\sigma_{nn} + \sum_{i < n} w_i(\sigma_{nn}-\sigma_{in}-\sigma_{kn}+\sigma_{ki})$$

$$\hat{b} = \begin{pmatrix} \sigma_{1n}-\sigma \\ \vdots \\ \sigma_{n-1,n}-\sigma \end{pmatrix}$$

$$s_{ik} = \sigma-\sigma_{in}-\sigma_{kn}+\sigma_{ki} = s_{ki}$$

$$s_{ii} = 2(\sigma - \sigma_{in})$$

$$\hat{C} = C[1:end-1][1:end-1] = \begin{pmatrix} \sigma & \ldots &\sigma_{1,n-1} \\ \vdots & \ddots & \vdots \\ \sigma_{1,n-1} & \ldots &\sigma \end{pmatrix}$$

$$C_n = \begin{pmatrix} \sigma_{1n} && \ldots && \sigma_{1n} \\ \vdots && \ddots && \vdots \\ \sigma_{n-1,n} && \dots && \sigma_{n-1,n} \\ \sigma && \ldots && \sigma\end{pmatrix}$$

$$C_n + C_n^T$$

$$\tilde{C} = \begin{pmatrix} 0 && \sigma_{12} && \sigma_{13} && \ldots && \sigma_{1,n-1} \\  && 0 && \sigma_{23} && \ldots && \sigma_{2,n-1} \\  &&  && \ddots && \ldots && \vdots \\ && \text{\huge0} && && 0 && \sigma_{n-1,n-1} \\ && && && && 0 \end{pmatrix}$$

$$\hat{S} = \tilde{C} + \tilde{C}^T + \sigma \cdot (I + \mathbb{1}) - (C_n + C_n^T)$$

$$\hat{w} = \begin{pmatrix} w_1 \\ \vdots \\ w_{n-1} \end{pmatrix}$$

$$\hat{S} \hat{w} = \hat{b} \Leftrightarrow \hat{w}=\hat{S} \backslash \hat{b}$$

Given $n$ assets