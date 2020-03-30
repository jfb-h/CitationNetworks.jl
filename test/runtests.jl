using CitationNetworks
using Test
using LightGraphs

A = [
 0  0  1  0  0  0  0  0  0  0  0
 0  0  1  1  0  0  0  0  0  0  0
 0  0  0  0  1  0  1  0  0  0  0
 0  0  0  0  0  1  0  0  0  1  1
 0  0  0  0  0  0  0  1  1  0  0
 0  0  0  0  0  0  0  0  1  1  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  0
]

g = LightGraphs.SimpleDiGraph(A)
spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]

spc = compute_weights_spc(g)
gw = add_weights(g, spc)

# gplot(g, nodelabel = 1:nv(g), edgelabel = spc,
# nodefillc = colorant"orange", nodestrokec = colorant"white",
#  edgelabelc = colorant"white", edgelabelsize = 10)

@testset "SPC weights" begin
    @test all(compute_weights_spc(g) .== spc_true)
    @test all((Matrix(weights(gw)) .> 0) .== (A .> 0))
end
