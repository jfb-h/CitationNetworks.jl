using CitationNetworks
using Test
using LightGraphs#master
using SimpleWeightedGraphs

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
lfmp_true = [2, 4, 6, 9, 10]
lfmp_weights_true = [4, 2, 1, 1]
edges_on_lfmp_true = [false, false, true, false, false, true, false, false, false, false, true, true]
g = SimpleDiGraph(A)
spc, spc_total = compute_weights_spc(g, normalize = false)
g = add_weights(g, spc)
mp = main_path(g)
mp_net = main_path(g, CitationNetworks.get_sources(g))
gmp = SimpleDiGraph(mp_net.edges)

# using GraphPlot, Colors
# gplot(gmp, nodelabel = 1:nv(gmp), edgelabel = mp_net.weights,
# nodefillc = colorant"orange", nodestrokec = colorant"white",
#  edgelabelc = colorant"white", edgelabelsize = 10)

@testset "SPC weights" begin
    @test all(spc .== spc_true)
    @test all((Matrix(weights(g)) .> 0) .== (A .> 0))
end

@testset "main paths" begin
    @test [e in mp.edges for e in edges(g)] == edges_on_lfmp_true
    @test mp.weights == lfmp_weights_true
    @test vertices(gmp)[degree(gmp) .!= 0] == lfmp_true
    @test main_path(g, 1, ForwardLocal()).weights == [3, 4, 2, 2]
end
