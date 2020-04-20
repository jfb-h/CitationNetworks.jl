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

g = SimpleDiGraph(A)
ew_spc, vw_spc, tf_spc = compute_weights_spc(g, normalize = false)

# SimpleWeightedDiGraph

# g = add_weights(g, ew_spc)
#
# lfmp1 = main_path(g)
# lfmp2 = main_path(g, 2)
# lfmp3 = main_path(g, [1,2])
# lfmp_g = SimpleWeightedDiGraph(src.(mp3.edges), dst.(mp3.edges), mp3.weights)

# MetaDiGraph

eldf = DataFrame(
  from = [src(e) for e in edges(g)],
  to = [dst(e) for e in edges(g)],
  weight = ew_spc
)

mg = MetaDiGraph(eldf, :from, :to, weight = :weight)

lfmp1 = main_path(mg)          # start at source(s) with max outgoing
lfmp2 = main_path(mg, 1)       # start at vertex 2
lfmp3 = main_path(mg, [1,2])   # start at vertices 1 and 2

set_mp_prop!(mg, lfmp1, :lfmp)

lbmp1 = main_path(mg, BackwardLocal())            # start at sink(s) with max incoming
lbmp2 = main_path(mg, 10, BackwardLocal())        # start at vertex 10
lbmp3 = main_path(mg, [10,7], BackwardLocal())    # start at vertices 1 and 2

set_mp_prop!(mg, lbmp1, :lbmp)


spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]

@testset "SPC weights" begin
    @test all(ew_spc .== spc_true)
    #@test all((Matrix(weights(mg)) .> 0) .== (A .> 0)) # check default weight in MetaGraphs
    @test tf_spc == 10.0
end

lfmp_true = [2, 4, 6, 9, 10]
lfmp_weights_true = [4, 2, 1, 1]
edges_on_lfmp_true = [false, false, true, false, false, true, false, false, false, false, true, true]

@testset "local forward main path" begin
    @test [get_prop(mg, e, :lfmp) for e in edges(mg)] == edges_on_lfmp_true
    @test lfmp1.weights == lfmp_weights_true
    @test collect(filter_vertices(mg, :lfmp, true)) == lfmp_true
    @test main_path(mg, 1).weights == [3, 4, 2, 2]
end

lbmp_true = [1, 2, 3, 5, 7, 8, 9]
lbmp_weights_true = [2, 2, 2, 3, 3, 4]
edges_on_lbmp_true = [true, true, false, true, true, false, false, false, true, true, false, false]

@testset "local backward main path" begin
    @test [get_prop(mg, e, :lbmp) for e in edges(mg)] == edges_on_lbmp_true
    @test lbmp1.weights == lbmp_weights_true
    @test collect(filter_vertices(mg, :lbmp, true)) == lbmp_true
    @test main_path(mg, 7, BackwardLocal()).weights == [2, 3, 3]
end
