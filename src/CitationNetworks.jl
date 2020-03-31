module CitationNetworks
using LightGraphs#master
const SP = LightGraphs.ShortestPaths
using SimpleWeightedGraphs

# change LG to 1.4 when available

include("compute_weights.jl")
include("find_paths.jl")

export compute_weights_spc, add_weights, mainpath_forward_local

end # module
