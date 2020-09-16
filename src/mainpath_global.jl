
function max_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    wnb = w[v, nb]
    length(nb) == 0 && return nb
    nb[wnb .== maximum(wnb)]
end
  
max_outneighbors(g::AbstractMetaGraph, v::Integer) = max_outneighbors(g, v, weights(g))
  
function max_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = inneighbors(g, v)
    wnb = w[nb, v]
    length(nb) == 0 && return nb
    nb[wnb .== maximum(wnb)]
end
  
max_inneighbors(g::AbstractMetaGraph, v::Integer) = max_inneighbors(g, v, weights(g))

function max_outweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = outneighbors(g, v)
    length(nb) > 0 || return 0
    maximum(w[v, nb])
end

function max_inweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where {U <: Real}
    nb = inneighbors(g, v)
    length(nb) > 0 || return 0
    maximum(w[nb, v])
end
  
abstract type MainPathAlgorithm <: AbstractGraphAlgorithm end
abstract type MainPathResult <: AbstractGraphResult end

struct StandardGlobal <: MainPathAlgorithm end

struct StandardGlobalResult{T<:Integer, U<:Real} <: MainPathResult
    edges::Vector{SimpleEdge{T}}
    weights::Vector{U}
    totalweight::U
end

function mainpath(
    g::AbstractGraph{T},
    weights::AbstractMatrix{U},
    ::StandardGlobal) where T <: Integer where U <: Real

    add_source_target!(g)
    vt = topological_sort(g)
    source = vt[1]; sink = vt[end]
    n = nv(g)
    lpath = zeros(U, n)
    lpath[vt[1]] = 1.0

    @inbounds for v in vt
        (v == n-1 || v == n-2) && continue
        nb = inneighbors(g, v)
        if length(nb) == 0
            lpath[v] = 0
        else
            val = lpath[nb]
            lpath[v] = maximum(val) + weights[nb[findmax(val)[2]], v]
        end
    end

    # This is adapted from LightGraphs breadthfirst

    start = sink
    visited = falses(n)
    cur_level = Vector{T}()
    sizehint!(cur_level, n)
    next_level = Vector{T}()
    sizehint!(next_level, n)
    edgesmp = Vector{SimpleEdge{T}}()
    push!(cur_level, start)

    while !isempty(cur_level)
        @inbounds for v in cur_level
            nb = inneighbors(g, v)
            length(nb) == 0 && continue
            val = lpath[nb]
            maxnb = nb[val .== maximum(val)]
            for u in maxnb
                if !visited[u]
                    (v != sink && u != source) && push!(edgesmp, SimpleEdge(u, v))
                    push!(next_level, u)
                    visited[u] = true
                else
                    (v != sink && u != source) && push!(edgesmp, SimpleEdge(u, v))
                end
            end
        end
        empty!(cur_level)
        cur_level, next_level = next_level, cur_level
        sort!(cur_level, alg=QuickSort)
    end

    for s in [sink, source] rem_vertex!(g, s) end
    w = [weights[src(e), dst(e)] for e in edgesmp]
    return StandardGlobalResult(edgesmp, w, sum(w))
end

mainpath(g::AbstractGraph{T}, ::StandardGlobal) where {T <: Integer} = mainpath(g, weights(g), StandardGlobal())
