

add_weights = function(g, weights)
    from = [src(e) for e in edges(g)]
    to = [dst(e) for e in edges(g)]
    SimpleWeightedDiGraph(from, to, weights)
end


# mp_iter = function(g::SimpleWeightedDiGraph{T}, source::T) where T <: Integer
#     V = vertices(g)
#     sinks = getindex(V, outdegree(g) .== 0)
#
#     onb_max = function(g, u)
#         nb = outneighbors(g, u)
#         val = zeros(length(nb))
#         for (i, v) in enumerate(nb)
#             val[i] = get_weight(g, u, v)
#         end
#         maxval = maximum(val)
#         return nb[val .== maxval], maxval
#     end
#
#     mp = [source]
#     v = source
#     while !(v in sinks)
#         v = onb_max(g, v)[1][1]
#         push!(mp, v)
#     end
#     return mp
# end
