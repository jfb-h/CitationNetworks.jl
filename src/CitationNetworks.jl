module CitationNetworks

using LightGraphs
using LightGraphs.SimpleGraphs
using LightGraphs.Traversals
using LightGraphs.Traversals: TraversalState, TraversalAlgorithm, BreadthFirst, traverse_graph!, topological_sort
import LightGraphs.Traversals: newvisitfn!, revisitfn!
using LightGraphs.ShortestPaths
using LightGraphs.ShortestPaths: AbstractGraphAlgorithm, AbstractGraphResult
using MetaGraphs

# change LG to 2.0 when available
export compute_weights_spc, add_weights, set_mp_prop!,
main_path, ForwardLocal, BackwardLocal, StandardGlobal

include("weights_spc.jl")
include("mainpath_global.jl")
include("mainpath_local.jl")
include("mainpath_gbfp.jl")
include("genetic_knowper.jl")
include("convenience.jl")

export weights_spc
export mainpath
export ForwardLocal, BackwardLocal, StandardGlobal, GBFP
export genetic_knowper
export set_mp_prop!

end # module
