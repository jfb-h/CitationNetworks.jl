
add_weights = function(g::SimpleDiGraph{T}, weights) where T <: Integer
    from = [src(e) for e in edges(g)]
    to = [dst(e) for e in edges(g)]
    SimpleWeightedDiGraph(from, to, weights)
end

max_outneighbors = function(g, v)
  nb = outneighbors(g, v)
  w = weights(g)[v, nb]
  nb[w .== maximum(w)]
end

# This is most likely inefficient

max_outweight = function(g, v)
  nb = outneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(weights(g)[v, nb])
end

mainpath_forward_local = function(g)
  sources = get_sources(g)
  sinks = get_sinks(g)

  add_vertex!(g)
  t = vertices(g)[end]
  for sink in sinks
      add_edge!(g, sink, t)
  end

  sw = [max_outweight(g, s) for s in sources]
  mp = sources[sw .== maximum(sw)]
  curr = copy(mp)

  while !all(curr .== t)
    next = Vector{Int64}()
    for u in curr
      u == t && continue
      maxnb = max_outneighbors(g, u)
      append!(next, maxnb)
    end
    curr = next
    append!(mp, next)
  end

  rem_vertex!(g, t)
  return unique(mp[mp .!= t])
end

# find_maxpath = function(g::SimpleWeightedDiGraph{T}) where T <: Integer
#     SP.shortest_paths(g, -weights(g), SP.DistributedJohnson())
# end

# LGS.shortest_paths(g,)
# LGS.paths(maxpath)
# LGS.reconstruct_path()
