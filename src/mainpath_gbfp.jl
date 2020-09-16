
function genetic_kp(g::AbstractGraph{T}) where T <: Integer 

    n = nv(g)
    sinks = get_sinks(g)
    source = get_sources(g)
    source_idx = falses(n)
    source_idx[source] .= true

    w = 1 ./ indegree(g)
    kp = zeros(n)
    kp[sinks] .= 1

    layer = sinks
    while length(layer) > 0
        new = T[]
        
        for v in layer
            inb = inneighbors(g, v)

            for nb in inb
                kp[nb] += w[nb] * kp[nb]
                source_idx[nb] || push!(new, nb)
            end 

            layer = new
        end
    end

    return kp

end 



