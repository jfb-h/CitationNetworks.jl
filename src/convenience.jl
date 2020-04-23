
function set_mp_prop!(g::MetaDiGraph{T, U}, mp::MainPathResult, sym::Symbol) where T <: Integer where U <: Real
        [set_prop!(g, e, sym, false) for e in edges(g)]
        [set_prop!(g, e, sym, true) for e in mp.edges]
        vmp = unique([src.(mp.edges); dst.(mp.edges)])
        [set_prop!(g, v, sym, false) for v in vertices(g)]
        [set_prop!(g, v, sym, true) for v in vmp]
end

add_weights = function(g::SimpleDiGraph{T}, weights::Vector{U}) where T <: Integer where U <: Real
    from = [src(e) for e in edges(g)]
    to = [dst(e) for e in edges(g)]
    SimpleWeightedDiGraph(from, to, weights)
end
