using CitationNetworks
using Test
using LightGraphs#master
using SimpleWeightedGraphs
using Traceur

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

spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]
mp_true = [2, 4, 6, 9, 10]

g = SimpleDiGraph(A)
spc = compute_weights_spc(g, normalize = false)
g = add_weights(g, spc)
mp = mainpath_forward_local(g)

# using GraphPlot
# using Colors
#
# gplot(g, nodelabel = 1:nv(g), edgelabel = spc,
# nodefillc = colorant"orange", nodestrokec = colorant"white",
#  edgelabelc = colorant"white", edgelabelsize = 10)

@testset "SPC weights" begin
    @test all(spc .== spc_true)
    @test all((Matrix(weights(g)) .> 0) .== (A .> 0))
end

@testset "main paths" begin
    @test (mp == mp_true)
end
