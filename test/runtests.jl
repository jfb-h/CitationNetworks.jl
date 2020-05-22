using CitationNetworks
using LightGraphs#master
using LightGraphs.SimpleGraphs
using DataFrames
using SimpleWeightedGraphs, MetaGraphs, GraphDataFrameBridge
using Test

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

# MetaDiGraph

eldf = DataFrame(
  from = [src(e) for e in edges(g)],
  to = [dst(e) for e in edges(g)],
  weight = ew_spc
)

mg = MetaDiGraph(eldf, :from, :to, weight = :weight)


@testset "SPC weights" begin
    spc_true = [3, 3, 4, 4, 2, 2, 1, 1, 2, 2, 1, 1]

    @test all(ew_spc .== spc_true)
    #@test all((Matrix(weights(mg)) .> 0) .== (A .> 0)) # check default weight in MetaGraphs
    @test tf_spc == 10.0
end

@testset "local forward main path" begin
    flmp1 = main_path(mg, ForwardLocal())
    flmp2 = main_path(mg, 1, ForwardLocal())
    flmp3 = main_path(mg, [1,2], weights(g), ForwardLocal())

    set_mp_prop!(mg, flmp1, :flmp)

    flmp_true = [2, 4, 6, 9, 10]
    flmp_weights_true = [4, 2, 1, 1]
    edges_on_flmp_true = [false, false, true, false, false, true, false, false, false, false, true, true]

    @test [get_prop(mg, e, :flmp) for e in edges(mg)] == edges_on_flmp_true
    @test flmp1.weights == flmp_weights_true
    @test collect(filter_vertices(mg, :flmp, true)) == flmp_true
    @test main_path(mg, 1, ForwardLocal()).weights == [3, 4, 2, 2]
end

@testset "local backward main path" begin

    blmp1 = main_path(mg, BackwardLocal())
    blmp2 = main_path(mg, 10, BackwardLocal())
    blmp3 = main_path(mg, [10, 7], weights(mg), BackwardLocal())

    set_mp_prop!(mg, blmp1, :blmp)

    blmp_true = [1, 2, 3, 5, 7, 8, 9]
    blmp_weights_true = [2, 2, 2, 3, 3, 4]
    edges_on_blmp_true = [true, true, false, true, true, false, false, false, true, true, false, false]

    @test [get_prop(mg, e, :blmp) for e in edges(mg)] == edges_on_blmp_true
    @test blmp1.weights == blmp_weights_true
    @test collect(filter_vertices(mg, :blmp, true)) == blmp_true
    @test main_path(mg, 7, BackwardLocal()).weights == [2, 3, 3]
end

@testset "standard global main path" begin

    sgmp1 = main_path(mg, StandardGlobal())

    set_mp_prop!(mg, sgmp1, :sgmp)

    sgmp_true = [1, 2, 3, 5, 8, 9]
    sgmp_weights_true = [2, 2, 4, 3, 3]
    edges_on_sgmp_true = [true, true, false, true, false, false, false, false, true, true, false, false]

    @test [get_prop(mg, e, :sgmp) for e in edges(mg)] == edges_on_sgmp_true
    @test sgmp1.weights == sgmp_weights_true
    @test collect(filter_vertices(mg, :sgmp, true)) == sgmp_true
end
