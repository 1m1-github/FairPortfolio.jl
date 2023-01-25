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

$$w_n = 1 - \sum_{i<n} w_i$$

$$\frac{\partial{}}{\partial{w_k}}, k < n$$

$$\frac{\partial{w_n}}{\partial{w_k}} = -1$$

<!-- $$= \underbrace{\sum_{i, j < n} w_i w_j \sigma_{ij}}_A + \underbrace{2 \sum_{j < n} w_j (1 - \sum_{i<n} w_i) \sigma_{jn}}_B + \underbrace{(1 - \sum_{i<n} w_i)^2 \sigma_{nn}}_C$$ -->

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

