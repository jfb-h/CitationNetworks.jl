
function max_outneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = outneighbors(g, v)
  wnb = w[v, nb]
  length(nb) == 0 && return nb
  nb[wnb .== maximum(wnb)]
end

max_outneighbors(g::AbstractMetaGraph, v::Integer) = max_outneighbors(g, v, weights(g))

function max_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = inneighbors(g, v)
  wnb = w[nb, v]
  length(nb) == 0 && return nb
  nb[wnb .== maximum(wnb)]
end

max_inneighbors(g::AbstractMetaGraph, v::Integer) = max_inneighbors(g, v, weights(g))

function max_outweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = outneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(w[v, nb])
end

function max_inweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = inneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(w[nb, v])
end

abstract type MainPathAlgorithm <: AbstractGraphAlgorithm end
abstract type MainPathResult <: AbstractGraphResult end


#include("forward_local.jl")
#include("backward_local.jl")
#include("standard_global.jl")

include("mainpath_local.jl")
include("mainpath_global.jl")
