### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 0120e370-f8f5-11ea-1b65-9d29b0b5b647
begin
	using LightGraphs
	using LightGraphs.SimpleGraphs
	using MetaGraphs
	using CitationNetworks
	using GraphPlot
end

# ╔═╡ 0ba77020-f8f5-11ea-025d-61768c938c5c
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
];

# ╔═╡ 2680e980-f8f5-11ea-10c2-fbf1d8358506
g = SimpleDiGraph(A)

# ╔═╡ 53e56540-f8f5-11ea-1189-99d9421b9146
gplot(g, nodelabel=1:nv(g))

# ╔═╡ 7563a7d0-f8f6-11ea-00ae-bbee824a385c
genetic_knowper(g, normalize=:none)

# ╔═╡ 6b60e68e-f8f5-11ea-25f9-f3075e37b317
mpres = mainpath(g, 3, GBFP(), normalize=:none)

# ╔═╡ 3404b0a0-f8f5-11ea-1cb0-4f35dff35a1f
mpnet, vlabels = induced_subgraph(g, mpres.edges)

# ╔═╡ bd8334f0-f8f5-11ea-0def-dda12adf86e7
gplot(mpnet, nodelabel=vlabels)

# ╔═╡ 5bb78380-f8f9-11ea-2b66-1529d729d0d9
function add_weights(g, w)
    mg = MetaDiGraph(g)
	for (i,e) in enumerate(edges(g))
		set_prop!(mg, e, :weight, w[i])
	end
	return mg
end

# ╔═╡ c9fba690-f8f5-11ea-068f-7393d3245730
begin
	spc = weights_spc(g).edgeweights
	mg = add_weights(g, spc)
	mpfl = mainpath(mg, ForwardLocal())
	mpbl = mainpath(mg, BackwardLocal())
end

# ╔═╡ Cell order:
# ╠═0120e370-f8f5-11ea-1b65-9d29b0b5b647
# ╠═0ba77020-f8f5-11ea-025d-61768c938c5c
# ╠═2680e980-f8f5-11ea-10c2-fbf1d8358506
# ╠═53e56540-f8f5-11ea-1189-99d9421b9146
# ╠═7563a7d0-f8f6-11ea-00ae-bbee824a385c
# ╠═6b60e68e-f8f5-11ea-25f9-f3075e37b317
# ╠═3404b0a0-f8f5-11ea-1cb0-4f35dff35a1f
# ╠═bd8334f0-f8f5-11ea-0def-dda12adf86e7
# ╠═5bb78380-f8f9-11ea-2b66-1529d729d0d9
# ╠═c9fba690-f8f5-11ea-068f-7393d3245730
