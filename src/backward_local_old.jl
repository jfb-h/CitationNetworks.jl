
struct BackwardLocal <: MainPathAlgorithm end

struct BackwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
  edges::Vector{Edge{T}}
  weights::Vector{U}
end

function backward_local(
  g::AbstractGraph{T},
  s::Vector{R},
  weights::AbstractMatrix{U}
  ) where {T,R <: Integer} where U <: Real

  source = ifelse.(indegree(g) .== 0, true, false)
  visited = falses(nv(g))
  S = copy(s)
  mp_e = Vector{Edge{T}}()

  while !all(source[S])
    next = Vector{T}()
    for u in S
      (source[u] || visited[u]) && continue
      maxnb = max_inneighbors(g, u, weights)
      append!(next, maxnb)
      [push!(mp_e, Edge(nb, u)) for nb in maxnb]
      visited[u] = true
    end
    S = next
  end

  from = src.(mp_e)
  to = dst.(mp_e)
  w_e = [weights[s,t] for (s, t) in zip(from, to)]
  return BackwardLocalResult(mp_e, w_e)
end

function main_path(
  g::AbstractGraph{T},
  s::AbstractVector{S},
  weights::AbstractMatrix{U},
  ::BackwardLocal
  ) where {S, T <: Integer} where U <: Real

  return backward_local(g, s, weights)
end

function main_path(
  g::AbstractGraph{T},
  s::AbstractVector{S},
  ::BackwardLocal
  ) where {S, T <: Integer} where U <: Real

  return backward_local(g, s, weights(g))
end

function main_path(
  g::AbstractGraph{T},
  s::Integer,
  ::BackwardLocal
  ) where {T <: Integer}

   return backward_local(g, [s], weights(g))
 end

function main_path(
  g::AbstractGraph{T},
  ::BackwardLocal
  ) where T <: Integer where U <: Real

  w = weights(g)
  sinks = get_sinks(g)
  sweights = [max_inweight(g, v, w) for v in sinks]
  s = sinks[sweights .== maximum(sweights)]

  return backward_local(g, s, w)
end
