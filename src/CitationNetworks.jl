module CitationNetworks

using LightGraphs#master
using SimpleWeightedGraphs, MetaGraphs
const LGS = LightGraphs.ShortestPaths

# change LG to 1.4 / 2.0 when available

include("compute_weights.jl")
include("find_paths.jl")
include("convenience.jl")

export compute_weights_spc, add_weights, main_path, ForwardLocal, StandardGlobal, set_mp_prop!

end # module
