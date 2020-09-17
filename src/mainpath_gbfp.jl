
struct GBFP <: MainPathAlgorithm end

struct GBFPResult{T<:Integer} <: MainPathResult
    edges::Vector{SimpleEdge{T}}
end

function vmax_outneighbors(g, v, w) 
    nb = outneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

function vmax_inneighbors(g, v, w)     
    nb = inneighbors(g, v)
    length(nb) == 0 && return nb
    wnb = w[nb]
    return nb[wnb .== maximum(wnb)]
end

function mainpath(
    g::AbstractGraph{T}, 
    cutoff, 
    ::GBFP; 
    normalize=:global) where T <: Integer
    
    gkp = genetic_knowper(g, normalize=normalize)
    start = findall(gkp .>= cutoff)

    forwardstate = MainPathState(Vector{SimpleEdge{T}}())
    backwardstate = MainPathState(Vector{SimpleEdge{T}}())
    traverse_graph!(g, start, BreadthFirst(neighborfn = (g, v) -> vmax_outneighbors(g, v, gkp)), forwardstate) 
    traverse_graph!(g, start, BreadthFirst(neighborfn = (g, v) -> vmax_inneighbors(g, v, gkp)), backwardstate) 

    combined = vcat(forwardstate.edges, reverse.(backwardstate.edges)) |> unique
    return GBFPResult(combined)
end
