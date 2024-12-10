# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

import Test
import Aqua
import LegendPlots

Test.@testset "Package ambiguities" begin
    Test.@test isempty(Test.detect_ambiguities(LegendPlots))
end # testset

Test.@testset "Aqua tests" begin
    Aqua.test_all(
        LegendPlots,
        ambiguities = true
    )
end # testset
