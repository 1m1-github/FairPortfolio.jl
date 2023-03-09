# C is cov matrix with a constant diagonal
function sleepbetter(C::Array{Float64,2})
 n = size(C,1)

 if n == 1 return [1.0] end

 Ŝ = C[1:end-1, 1:end-1] .+ C[end, end] .- C[1:end-1, end] .- C[end, 1:end-1]'
 b̂ = C[end, end] .- C[1:end-1, end]

 # solve linear equations
 ŵ = Ŝ \ b̂

 # add nth dimension
 push!(ŵ, 1.0 - sum(ŵ))
 
 # truncate
 for i in 1:n-1
  0 ≤ ŵ[i] && continue
  ŵ[i] = 0 
 end

 # normalize
 ŵ = ŵ ./ sum(ŵ)

 # code to check whether truncation is optimal
 # for i = 1:size(Index,1)
 #  if(2*CoVar(Index(i),m) >  CoVar(Index(i),Index(i)) + CoVar(m,m))
 #   disp('truncation to zero is not optimal');
 #  end
 # end

end

## test
# C = [0.1 0.02; 0.01 0.1]
# sleepbetter(C)