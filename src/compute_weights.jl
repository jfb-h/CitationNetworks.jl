
get_sources(g) = vertices(g)[indegree(g) .== 0]
get_sinks(g) = vertices(g)[outdegree(g) .== 0]

add_source_target! = function(g::SimpleDiGraph{T}) where T <: Integer
    sinks = get_sinks(g)
    sources = get_sources(g)

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

compute_weights_spc = function(g::SimpleDiGraph{T}; normalize = false) where T <: Integer
    add_source_target!(g)
    #@assert sum(indegree(g) .== 0) == 1 # make sure graph is augmented with single source / target
    #@assert sum(outdegree(g) .== 0) == 1
    vseqt = LightGraphs.Traversals.topological_sort(g)

    st = vseqt[[1, end]]
    N_m = N⁻(g, vseqt)
    N_p = N⁺(g, vseqt)
    total = N_p[st[1]] * N_m[st[2]]
    idx = [!(v in st) for v in vertices(g)]

    rem_vertices!(g, st)
    N_m = N_m[idx]
    N_p = N_p[idx]
    val = zeros(ne(g))

    for (i, e) in enumerate(edges(g))
        val[i] = N_m[src(e)] * N_p[dst(e)]
    end

    normalize && return val ./ total
    return val
end