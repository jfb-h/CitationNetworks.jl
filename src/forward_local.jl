
struct ForwardLocal <: MainPathAlgorithm end

struct ForwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
  edges::Vector{LightGraphs.SimpleGraphs.SimpleEdge{T}}
  weights::Vector{U}
end

function forward_local(
  g::AbstractGraph{T},
  s::Vector{S},
  weights::AbstractMatrix{U}
  ) where {T,S <: Integer} where U <: Real

  sink = ifelse.(outdegree(g) .== 0, true, false)
  visited = falses(nv(g))
  mp_e = Vector{LightGraphs.SimpleGraphs.SimpleEdge{T}}()

  #while length s != 0
  while !all(sink[s])
    next = Vector{T}()
    for u in s
      (sink[u] || visited[u]) && continue
      maxnb = max_outneighbors(g, u, weights)
      append!(next, maxnb)
      [push!(mp_e, Edge(u, nb)) for nb in maxnb]
      visited[u] = true
    end
    s = next
  end

  from = src.(mp_e)
  to = dst.(mp_e)
  w_e = [weights[s,t] for (s, t) in zip(from, to)]
  return ForwardLocalResult(mp_e, w_e)
end

function main_path(
  g::AbstractGraph{T},
  s::AbstractVector{S},
  weights::AbstractMatrix{U},
  ::ForwardLocal
  ) where {S, T <: Integer} where U <: Real

  return forward_local(g, s, weights(g))
end

function main_path(g::AbstractGraph{T}) where T <: Integer where U <: Real
  w = weights(g)
  sources = get_sources(g)
  sweights = [max_outweight(g, v, w) for v in sources]
  s = sources[sweights .== maximum(sweights)]

  return forward_local(g, s, w)
end

main_path(g::AbstractGraph{T}, s::AbstractVector{S}) where {S,T <: Integer} = forward_local(g, s, weights(g))
main_path(g::AbstractGraph{T}, s::U) where {T, U <: Integer} = main_path(g, [s])
