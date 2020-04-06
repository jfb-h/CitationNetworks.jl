
function max_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = outneighbors(g, v)
  wnb = w[v, nb]
  nb[wnb .== maximum(wnb)]
end

function max_outweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = outneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(w[v, nb])
end


abstract type MainPathAlgorithm <: LGS.AbstractGraphAlgorithm end
abstract type MainPathResult <: LGS.AbstractGraphResult end

function main_path end

include("forward_local.jl")
include("standard_global.jl")
