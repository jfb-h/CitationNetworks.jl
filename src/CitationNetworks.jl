module CitationNetworks

using LightGraphs#master
using MetaGraphs
const LGS = LightGraphs.ShortestPaths

# change LG to 1.4 / 2.0 when available

include("compute_weights.jl")
include("find_paths.jl")
include("convenience.jl")

export compute_weights_spc, add_weights, set_mp_prop!,
main_path, ForwardLocal, BackwardLocal, StandardGlobal


end # module
