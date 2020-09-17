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

include("weights_spc.jl")
include("mainpath_global.jl")
include("mainpath_local.jl")
include("mainpath_gbfp.jl")
include("convenience.jl")

export compute_weights_spc, add_weights
export mainpath, ForwardLocal, BackwardLocal, StandardGlobal
export genetic_knowper
export set_mp_prop!

end # module
