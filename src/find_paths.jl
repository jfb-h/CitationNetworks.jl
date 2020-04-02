
max_outneighbors = function(g::SimpleWeightedDiGraph{T}, v::Integer) where T <: Integer
  nb = outneighbors(g, v)
  w = weights(g)[v, nb]
  nb[w .== maximum(w)]
end

max_outweight = function(g::SimpleWeightedDiGraph{T}, v::Integer) where T <: Integer
  nb = outneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(weights(g)[v, nb])
end

# ### Examples
# """
# main_path(g)                   # uses ForwardLocal and starts at maxlocal
# main_path(g, 1)                # uses ForwardLocal and starts at vertex 1
# main_path(g, 1, BackwardLocal())  # uses BackwardLocal and starts vertex 1
# """
# ###

abstract type MainPathAlgorithm end

main_path(g::SimpleWeightedDiGraph{T, U}, s::Integer, alg::MainPathAlgorithm) where T <: Integer where U <: Real = main_path(g, s, alg)


include("forward_local.jl")
