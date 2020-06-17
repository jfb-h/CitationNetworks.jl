# CitationNetworks

[![Build Status](https://travis-ci.com/jfb-h/CitationNetworks.jl.svg?branch=master)](https://travis-ci.com/jfb-h/CitationNetworks.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/jfb-h/CitationNetworks.jl?svg=true)](https://ci.appveyor.com/project/jfb-h/CitationNetworks-jl)
[![Codecov](https://codecov.io/gh/jfb-h/CitationNetworks.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jfb-h/CitationNetworks.jl)
[![Coveralls](https://coveralls.io/repos/github/jfb-h/CitationNetworks.jl/badge.svg?branch=master)](https://coveralls.io/github/jfb-h/CitationNetworks.jl?branch=master)

This package implements methods for analysing citation networks, such as citations among academic papers or patents, in the Julia language. It builds heavily on the amazing [LightGraphs](https://github.com/JuliaGraphs/LightGraphs.jl) package. Current functionality mostly includes methods for main path analysis, and only a subset of those: SPC traversal weights, forward & backward local main paths and global main paths.

This package is a an alpha state, so expect things to not work and frequent changes.
