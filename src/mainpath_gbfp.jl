
function genetic_knowper(g::AbstractGraph{T}) where T <: Integer

    n = nv(g)
    sinks = get_sinks(g)
    sources = get_sources(g)
    source_idx = falses(n)
    source_idx[sources] .= true    
    visited = falses(n)
    visited[sinks] .= true

    w = 1 ./ indegree(g)
    od = outdegree(g)
    kp = zeros(n)
    kp[sinks] .= 1

    layer = sinks
    while length(layer) > 0
        new = T[]
        
        for v in layer
            inb = inneighbors(g, v)

            for nb in inb
                kp[nb] += w[v] * kp[v]
                od[nb] -= 1

                if !source_idx[nb] && od[nb] == 0
                    if !visited[nb] 
                        push!(new, nb)
                        visited[nb] = true
                    end
                end
            end 
        end

        layer = new
    end

    kp[sinks] .= 0
    return kp
end 

