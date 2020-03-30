module CitationNetworks

using LightGraphs, SimpleWeightedGraphs

include("compute_weights.jl")
include("find_path_critical.jl")

export compute_weights_spc, add_weights

end # module
