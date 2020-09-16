
mutable struct MainPathState{T<:Integer} <: TraversalState
    edges::Vector{SimpleEdge{T}}
    #weights::Vector{U}
end

function newvisitfn!(s::MainPathState, u, v)
    push!(s.edges, SimpleEdge(u, v))
    #push!(s.weights, weights(g, u, v))
    return true
end

function revisitfn!(s::MainPathState, u, v)
    push!(s.edges, SimpleEdge(u, v))
    #push!(s.weights, weights(g, u, v))
    return true
end

###########################
# Forward Local Main Path

struct ForwardLocal <: MainPathAlgorithm end

struct ForwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
    edges::Vector{SimpleEdge{T}}
    weights::Vector{U}
    totalweight::U
end

function mainpath(
    g::AbstractGraph{T},
    s,
    weights::AbstractMatrix{U},
    ::ForwardLocal) where T <: Integer where U <: Real

    edges = Vector{SimpleEdge{T}}()
    state = MainPathState(edges)
    traverse_graph!(g, s, BreadthFirst(neighborfn=max_outneighbors), state) # TODO max_outneighbors gets weights from the graph object not from the input matrix
    w = [weights[src(e), dst(e)] for e in state.edges]

    return ForwardLocalResult(state.edges, w, sum(w))
end

mainpath(g::AbstractGraph{T}, s, ::ForwardLocal) where T <: Integer = mainpath(g, s, weights(g), ForwardLocal())

function mainpath(
    g::AbstractGraph{T},
    weights::AbstractMatrix{U},
    ::ForwardLocal) where T <: Integer where U <: Real

    sources = get_sources(g)
    sweights = [max_outweight(g, v, weights) for v in sources]
    s = sources[sweights .== maximum(sweights)]

    mainpath(g, s, weights, ForwardLocal())
end

mainpath(g::AbstractGraph{T}, ::ForwardLocal) where T <: Integer = mainpath(g, weights(g), ForwardLocal())


###########################
# Backward Local Main Path

struct BackwardLocal <: MainPathAlgorithm end

struct BackwardLocalResult{T<:Integer, U<:Real} <: MainPathResult
    edges::Vector{SimpleEdge{T}}
    weights::Vector{U}
    totalweight::U
end

function mainpath(
    g::AbstractGraph{T},
    s,
    weights::AbstractMatrix{U},
    ::BackwardLocal) where T <: Integer where U <: Real

    edges = Vector{SimpleEdge{T}}()
    state = MainPathState(edges)
    traverse_graph!(g, s, BreadthFirst(neighborfn=max_inneighbors), state)
    state.edges = reverse.(state.edges)
    w = [weights[src(e), dst(e)] for e in state.edges]

    return BackwardLocalResult(state.edges, w, sum(w))
end

mainpath(g::AbstractGraph{T}, s, ::BackwardLocal) where T <: Integer = mainpath(g, s, weights(g), BackwardLocal())

function mainpath(
    g::AbstractGraph{T},
    weights::AbstractMatrix{U},
    ::BackwardLocal) where T <: Integer where U <: Real

    sinks = get_sinks(g)
    sweights = [max_inweight(g, v, weights) for v in sinks]
    s = sinks[sweights .== maximum(sweights)]

    mainpath(g, s, weights, BackwardLocal())
end

mainpath(g::AbstractGraph{T}, ::BackwardLocal) where T <: Integer = mainpath(g, weights(g), BackwardLocal())
