
mutable struct MainPathState{T<:Integer} <: TraversalState
    edges::Vector{Edge{T}}
    #weights::Vector{U}
end

function newvisitfn!(s::MainPathState, u, v)
    push!(s.edges, Edge(u, v))
    #push!(s.weights, weights(g, u, v))
    return true
end

function revisitfn!(s::MainPathState, u, v)
    push!(s.edges, Edge(u, v))
    #push!(s.weights, weights(g, u, v))
    return true
end

###########################
# Forward Local Main Path

struct ForwardLocal <: MainPathAlgorithm end

struct ForwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
    edges::Vector{Edge{T}}
    weights::Vector{U}
    totalweight::U
end

function main_path(
    g::AbstractGraph{T},
    s,
    weights::AbstractMatrix{U},
    ::ForwardLocal) where T <: Integer where U <: Real

    edges = Vector{Edge{T}}()
    state = MainPathState(edges)
    traverse_graph!(g, s, BreadthFirst(neighborfn=max_outneighbors), state) # TODO max_outneighbors gets weights from the graph object not from the input matrix
    w = [weights[src(e), dst(e)] for e in state.edges]

    return ForwardLocalResult(state.edges, w, sum(w))
end

main_path(g::AbstractGraph{T}, s, ::ForwardLocal) where T <: Integer = main_path(g, s, weights(g), ForwardLocal())

function main_path(
    g::AbstractGraph{T},
    weights::AbstractMatrix{U},
    ::ForwardLocal) where T <: Integer where U <: Real

    sources = get_sources(g)
    sweights = [max_outweight(g, v, weights) for v in sources]
    s = sources[sweights .== maximum(sweights)]

    main_path(g, s, weights, ForwardLocal())
end

main_path(g::AbstractGraph{T}, ::ForwardLocal) where T <: Integer = main_path(g, weights(g), ForwardLocal())


###########################
# Backward Local Main Path

struct BackwardLocal <: MainPathAlgorithm end

struct BackwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
    edges::Vector{Edge{T}}
    weights::Vector{U}
    totalweight::U
end

function main_path(
    g::AbstractGraph{T},
    s,
    weights::AbstractMatrix{U},
    ::BackwardLocal) where T <: Integer where U <: Real

    edges = Vector{Edge{T}}()
    state = MainPathState(edges)
    traverse_graph!(g, s, BreadthFirst(neighborfn=max_inneighbors), state)
    state.edges = reverse.(state.edges)
    w = [weights[src(e), dst(e)] for e in state.edges]

    return BackwardLocalResult(state.edges, w, sum(w))
end

main_path(g::AbstractGraph{T}, s, ::BackwardLocal) where T <: Integer = main_path(g, s, weights(g), BackwardLocal())

function main_path(
    g::AbstractGraph{T},
    weights::AbstractMatrix{U},
    ::BackwardLocal) where T <: Integer where U <: Real

    sinks = get_sinks(g)
    sweights = [max_inweight(g, v, weights) for v in sinks]
    s = sinks[sweights .== maximum(sweights)]

    main_path(g, s, weights, BackwardLocal())
end

main_path(g::AbstractGraph{T}, ::BackwardLocal) where T <: Integer = main_path(g, weights(g), BackwardLocal())
