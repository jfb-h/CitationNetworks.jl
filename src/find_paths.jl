
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

function max_inneighbors(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = inneighbors(g, v)
  wnb = w[nb, v]
  nb[wnb .== maximum(wnb)]
end

function max_inweight(g::AbstractGraph{T}, v::S, w::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real
  nb = inneighbors(g, v)
  length(nb) > 0 || return 0
  maximum(w[nb, v])
end


abstract type MainPathAlgorithm <: LGS.AbstractGraphAlgorithm end
abstract type MainPathResult <: LGS.AbstractGraphResult end

include("forward_local.jl")
include("backward_local.jl")
include("standard_global.jl")

main_path(g::AbstractGraph{T}) where T <: Integer = main_path(g, ForwardLocal())
main_path(g::AbstractGraph{T}, s::AbstractVector{S}) where {S,T <: Integer} = main_path(g, s, ForwardLocal())
main_path(g::AbstractGraph{T}, s::Integer) where {T <: Integer} = main_path(g, [s], ForwardLocal())
main_path(g::AbstractGraph{T}, s::AbstractVector{S}, weights::AbstractMatrix{U}) where {S,T <: Integer} where U <: Real = main_path(g, s, weights, ForwardLocal())
