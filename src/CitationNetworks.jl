module CitationNetworks

using LightGraphs#master
using SimpleWeightedGraphs

# change LG to 1.4 / 2.0 when available

include("compute_weights.jl")
include("find_paths.jl")

export compute_weights_spc, add_weights, main_path, ForwardLocal

end # module
