# n assets

function optimize(prices::Matrix)
prices
end

optimize(covariance_1)
optimize(covariance_2)

# C is covariance matrix (square, symmetric) with a constant diagonal of {assets}_i=1...n
abstract type FullAndConstantDiagonalCoVariance2 <: Matrix{Float64}
FullAndConstantDiagonalCoVariance <: Matrix{Float64}
covariance_1 = [2.0 1; 1 1]::FullAndConstantDiagonalCoVariance
covariance_2 = [2.0 1; 1 1]::Matrix
convert!(covariance_1)
convert!(covariance_2)
function convert!(covariance::FullAndConstantDiagonalCoVariance)
    (n, m) = size(covariance)
    @assert(n == m)
    σ = mean(diag(covariance))
    for i in 1:n
        covariance[i, i] = σ
    end
    covariance
end

function optimize(C::FullAndConstantDiagonalCoVariance)
    n = size(C,1)
   
    if n == 1 return [1.0] end
   
    # k < n, i < n, 
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
   