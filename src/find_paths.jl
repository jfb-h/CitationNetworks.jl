
add_weights = function(g::SimpleDiGraph{T}, weights::Vector{U}) where T <: Integer where U <: Real
    from = [src(e) for e in edges(g)]
    to = [dst(e) for e in edges(g)]
    SimpleWeightedDiGraph(from, to, weights)
end

max_outneighbors = function(g::SimpleWeightedDiGraph{T}, v::T) where T <: Integer
  nb = outneighbors(g, v)
  w = weights(g)[v, nb]
  nb[w .== maximum(w)]
end

max_outweight = function(g::SimpleWeightedDiGraph{T}, v::T) where T <: Integer
  nb = outneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(weights(g)[v, nb])
end

# This is most likely inefficient

mainpath_forward_local = function(g::SimpleWeightedDiGraph{T}) where T <: Integer
  sources = get_sources(g)
  sinks = get_sinks(g)

  sw = [max_outweight(g, s) for s in sources]
  #mp_v = sources[sw .== maximum(sw)]
  curr = sources[sw .== maximum(sw)]
  mp_e = Vector{LightGraphs.SimpleGraphs.SimpleEdge{T}}()

  while !all([u in sinks for u in curr])
    next = Vector{T}()
    for u in curr
      u in sinks && continue
      maxnb = max_outneighbors(g, u)
      append!(next, maxnb)
      [push!(mp_e, Edge(u, nb)) for nb in maxnb]
    end
    curr = next
    #append!(mp_v, next)
  end

  from = [src(e) for e in mp_e]
  to = [dst(e) for e in mp_e]
  weight = [get_weight(g, s, t) for (s, t) in zip(from, to)]
  return (edges = mp_e, weights = weight)
end


# find_maxpath = function(g::SimpleWeightedDiGraph{T}) where T <: Integer
#     SP.shortest_paths(g, -weights(g), SP.DistributedJohnson())
# end

# LGS.shortest_paths(g,)
# LGS.paths(maxpath)
# LGS.reconstruct_path()
