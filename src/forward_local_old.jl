
struct ForwardLocal <: MainPathAlgorithm end

struct ForwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
  edges::Vector{Edge{T}}
  weights::Vector{U}
end

function forward_local(
  g::AbstractGraph{T},
  s::Vector{R},
  weights::AbstractMatrix{U}
  ) where {T,R <: Integer} where U <: Real

  sink = ifelse.(outdegree(g) .== 0, true, false)
  visited = falses(nv(g))
  S = copy(s)
  mp_e = Vector{Edge{T}}()

  while !all(sink[S])
    next = Vector{T}()
    for u in S
      (sink[u] || visited[u]) && continue
      maxnb = max_outneighbors(g, u, weights)
      append!(next, maxnb)
      [push!(mp_e, Edge(u, nb)) for nb in maxnb]
      visited[u] = true
    end
    S = next
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

  return forward_local(g, s, weights)
end

function main_path(
  g::AbstractGraph{T},
  s::AbstractVector{S},
  ::ForwardLocal
  ) where {S, T <: Integer}

  return forward_local(g, s, weights(g))
end

function main_path(
  g::AbstractGraph{T},
  s::U,
  ::ForwardLocal
  ) where {T, U <: Integer}

   return forward_local(g, [s], weights(g))
 end

function main_path(
  g::AbstractGraph{T},
  ::ForwardLocal
  ) where T <: Integer

  w = weights(g)
  sources = get_sources(g)
  sweights = [max_outweight(g, v, w) for v in sources]
  s = sources[sweights .== maximum(sweights)]

  return forward_local(g, s, w)
end
