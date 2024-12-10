# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

"""
    LegendPlots

Template for Julia packages.
"""
module LegendPlots

    using Makie
    using CairoMakie

    using Dates
    using FileIO
    using Format
    using Measurements: value, uncertainty
    using PropDicts
    using Unitful

    include("propdicts.jl")
end
