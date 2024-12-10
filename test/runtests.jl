# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

import Test

Test.@testset "Package LegendPlots" begin
    include("test_aqua.jl")
    include("test_docs.jl")
end # testset
