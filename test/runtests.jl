using CitationNetworks
using LightGraphs#master
using DataFrames
using SimpleWeightedGraphs, MetaGraphs, GraphDataFrameBridge
using Test

const LGS = LightGraphs.ShortestPaths

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

# SimpleWeightedDiGraph

g = SimpleDiGraph(A)
ew_spc, vw_spc, tf_spc = compute_weights_spc(g, normalize = false)

g = add_weights(g, ew_spc)

mp1 = main_path(g)
mp2 = main_path(g, 2)
mp3 = main_path(g, [1,2])
gmp = SimpleWeightedDiGraph(src.(mp3.edges), dst.(mp3.edges), mp3.weights)


# MetaDiGraph

eldf = DataFrame(
  from = [src(e) for e in edges(g)],
  to = [dst(e) for e in edges(g)],
  weight = ew_spc
)

mg = MetaDiGraph(eldf, :from, :to, weight = :weight)
mp1 = main_path(mg)
mp2 = main_path(mg, 2)
mp3 = main_path(mg, [1,2])

set_mp_prop!(mg, mp1, :mainpath)


# using GraphPlot, Colors
# gplot(gmp, nodelabel = 1:nv(gmp), edgelabel = mp3.weights,
# nodefillc = colorant"orange", nodestrokec = colorant"white",
#  edgelabelc = colorant"white", edgelabelsize = 10)

spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]
lfmp_true = [2, 4, 6, 9, 10]
lfmp_weights_true = [4, 2, 1, 1]
edges_on_lfmp_true = [false, false, true, false, false, true, false, false, false, false, true, true]

@testset "SPC weights" begin
    @test all(ew_spc .== spc_true)
    @test all((Matrix(weights(g)) .> 0) .== (A .> 0))
    @test tf_spc == 10.0
end

@testset "main paths" begin
    @test [get_prop(mg, e, :mainpath) for e in edges(mg)] == edges_on_lfmp_true
    @test mp1.weights == lfmp_weights_true
    @test collect(filter_vertices(mg, :mainpath, true)) == lfmp_true
    @test main_path(mg, 1).weights == [3, 4, 2, 2]
end
