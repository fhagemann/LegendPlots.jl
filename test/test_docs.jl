# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

using Test
using LegendPlots
import Documenter

Documenter.DocMeta.setdocmeta!(
    LegendPlots,
    :DocTestSetup,
    :(using LegendPlots);
    recursive=true,
)
Documenter.doctest(LegendPlots)
