
struct StandardGlobal <: MainPathAlgorithm end

struct StandardGlobalResult{T<:Integer, U<:Real} <: MainPathResult
    edges::Vector{Edge{T}}
    weights::Vector{U}
    totalweight::U
end

function main_path(
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

    start = sink
    visited = falses(n)
    cur_level = Vector{T}()
    sizehint!(cur_level, n)
    next_level = Vector{T}()
    sizehint!(next_level, n)
    edgesmp = Vector{Edge{T}}()
    push!(cur_level, start)

    while !isempty(cur_level)
        @inbounds for v in cur_level
            nb = inneighbors(g, v)
            length(nb) == 0 && continue
            val = lpath[nb]
            maxnb = nb[val .== maximum(val)]
            for u in maxnb
                if !visited[u]
                    (v != sink && u != source) && push!(edgesmp, Edge(u, v))
                    push!(next_level, u)
                    visited[u] = true
                else
                    (v != sink && u != source) && push!(edgesmp, Edge(u, v))
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

main_path(g::AbstractGraph{T}, ::StandardGlobal) where T <: Integer = main_path(g, weights(g), StandardGlobal())
