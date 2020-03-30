
add_source_target! = function(g::SimpleDiGraph{T}) where T <: Integer
    V = vertices(g)
    sinks = getindex(V, outdegree(g) .== 0)
    sources = getindex(V, indegree(g) .== 0)

    add_vertex!(g)
    for source in sources
        add_edge!(g, vertices(g)[end], source)
    end

    add_vertex!(g)
    for sink in sinks
        add_edge!(g, sink, vertices(g)[end])
    end
end

N⁻ = function(g::SimpleDiGraph{T}, vseqt::Vector{T}) where T <: Integer
    nV = length(vseqt)
    val = zeros(nV)
    val[vseqt[1]] = 1.0
    for v in vseqt
        nb = outneighbors(g, v)
        val[nb] .+= val[v]
    end
    return val
end

N⁺ = function(g::SimpleDiGraph{T}, vseqt::Vector{T}) where T <: Integer
    nV = length(vseqt)
    val = zeros(nV)
    val[vseqt[nV]] = 1.0
    for v in reverse(vseqt)
        nb = inneighbors(g, v)
        val[nb] .+= val[v]
    end
    return val
end

compute_weights_spc = function(g::SimpleDiGraph{T}) where T <: Integer
    add_source_target!(g)
    vseqt = topological_sort_by_dfs(g)
    st = vseqt[[1, end]]
    idx = [!(v in st) for v in vertices(g)]
    N_m = N⁻(g, vseqt)[idx]
    N_p = N⁺(g, vseqt)[idx]
    rem_vertices!(g, st)

    val = zeros(ne(g))
    for (i, e) in enumerate(edges(g))
        val[i] = N_m[src(e)] * N_p[dst(e)]
    end
    return val
end
