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
    using TypedTables
    using Unitful

    """
        lplot(...)

        Create plots according to the LEGEND style guide for Juleana results
    """
    function lplot end
    export lplot

    # Define LEGEND colors
    const DeepCove = "#1A2A5B"
    const AchatBlue = "#07A9FF"
    const DiamondGrey = "#CCCCCC"

    # Define LEGEND font
    const LEGEND_FONT = "Roboto"

    include("propdicts.jl")
    include("specfits.jl")
end
