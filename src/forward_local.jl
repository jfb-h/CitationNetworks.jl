
struct ForwardLocal <: MainPathAlgorithm end

function forward_local(
  g::SimpleWeightedDiGraph{T, U},
  s::Vector{<:Integer}
  ) where T <: Integer where U <: Real

  sinks = get_sinks(g)

  add_vertex!(g)
  t = vertices(g)[end]
  for sink in sinks
      add_edge!(g, sink, t)
  end

  mp_e = Vector{LightGraphs.SimpleGraphs.SimpleEdge{T}}()

  while !all(s .== t)
    next = Vector{T}()
    for u in s
      u == t && continue
      maxnb = max_outneighbors(g, u)
      maxnb = maxnb[maxnb .!= t]
      append!(next, maxnb)
      [push!(mp_e, Edge(u, nb)) for nb in maxnb]
    end
    s = next
  end

  rem_vertex!(g, t)

  from = [src(e) for e in mp_e]
  to = [dst(e) for e in mp_e]
  weight = [get_weight(g, s, t) for (s, t) in zip(from, to)]
  return (edges = mp_e, weights = weight)
end


function main_path(
  g::SimpleWeightedDiGraph{T, U},
  ::ForwardLocal
  ) where T <: Integer where U <: Real

  sources = get_sources(g)
  sweights = [max_outweight(g, s) for s in sources]
  start = sources[sweights .== maximum(sweights)]

  return forward_local(g, start)
end

function main_path(
  g::SimpleWeightedDiGraph{T, U},
  s::Integer,
  ::ForwardLocal
  ) where T <: Integer where U <: Real

  start = [s]
  return forward_local(g, start)
end

function main_path(
  g::SimpleWeightedDiGraph{T, U},
  s::Vector{<:Integer},
  ::ForwardLocal
  ) where T <: Integer where U <: Real

  start = get_sources(g)
  return forward_local(g, start)
end

main_path(g::SimpleWeightedDiGraph{T, U}) where T <: Integer where U <: Real = main_path(g, ForwardLocal())
main_path(g::SimpleWeightedDiGraph{T, U}, s::Integer) where T <: Integer where U <: Real = main_path(g, s, ForwardLocal())
main_path(g::SimpleWeightedDiGraph{T, U}, s::Vector{<:Integer}) where T <: Integer where U <: Real = main_path(g, s, ForwardLocal())
