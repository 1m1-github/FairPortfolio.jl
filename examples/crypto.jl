using FairPortfolio

function price_vector_from_file(filename)
    prices = Float64[]
    f = open(filename, "r")
    lines = readlines(f)
    close(f)
    for i in eachindex(lines)
        i == 1 && continue # first line are headings
        pieces = split(lines[i], ',')
        price = parse(Float64, pieces[2])
        push!(prices, price)
    end
    prices
end
prices_btc = price_vector_from_file("examples/btc-usd-max.csv")
prices_eth = price_vector_from_file("examples/eth-usd-max.csv")
prices_doge = price_vector_from_file("examples/doge-usd-max.csv")
N = 2500 # each has at least N data points
prices = (prices_btc[end-N:end], prices_eth[end-N:end], prices_doge[end-N:end])

optimize(prices);