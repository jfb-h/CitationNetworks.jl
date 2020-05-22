module CitationNetworks

using LightGraphs#master
using LightGraphs.SimpleGraphs
using LightGraphs.Traversals
using LightGraphs.Traversals: TraversalState, TraversalAlgorithm, BreadthFirst, traverse_graph!, topological_sort
import LightGraphs.Traversals: newvisitfn!, revisitfn!
using LightGraphs.ShortestPaths
using LightGraphs.ShortestPaths: AbstractGraphAlgorithm, AbstractGraphResult
using MetaGraphs

# change LG to 1.4 / 2.0 when available

get_sources(g::AbstractGraph{T}) where T <: Integer = vertices(g)[indegree(g) .== 0]
get_sinks(g::AbstractGraph{T})  where T <: Integer = vertices(g)[outdegree(g) .== 0]

add_source_target! = function(g::AbstractGraph{T}) where T <: Integer
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

include("compute_weights.jl")
include("mainpath_global.jl")
include("mainpath_local.jl")
include("convenience.jl")

export compute_weights_spc, add_weights, set_mp_prop!,
main_path, ForwardLocal, BackwardLocal, StandardGlobal


end # module
