
struct StandardGlobal <: MainPathAlgorithm end

struct StandardGlobalResult{T, U <: Integer} <: MainPathResult
    parents::Vector{U}
    dists::Vector{T}
end

function edges_from_path(p::Vector{T}) where T <: Integer
    n = length(p)
    el = Vector{LightGraphs.SimpleGraphs.SimpleEdge}()
    sizehint!(el, n-1)
    for i = 1:n-1
        push!(el, Edge(p[i], p[i+1]))
    end
    return el
end

function main_path(
    g::AbstractGraph{U},
    w::AbstractMatrix{T},
    ::StandardGlobal
    ) where {T, U <: Integer}

    sources = CitationNetworks.get_sources(g)
    sp = LGS.shortest_paths(g, sources, -w, LGS.BellmanFord())

    sinks = get_sinks(g)
    dist = sp.dists[sinks]
    path = LGS.paths(sp)[sinks]
    idx = dist .== minimum(dist)
    mp = path[idx]
    epaths = Vector{LightGraphs.SimpleGraphs.SimpleEdge}()
    sizehint!(epaths, sum(length.(mp)))
    [append!(epaths, edges_from_path(p)) for p in mp]

    return unique(epaths)
end
