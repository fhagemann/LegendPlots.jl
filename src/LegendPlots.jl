# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

"""
    LegendPlots

Template for Julia packages.
"""
module LegendPlots

    # using Dates
    # using FileIO
    # using Format
    # using Measurements: value, uncertainty
    # using PropDicts
    # using TypedTables
    # using Unitful

    using Dates

    using MakieCore
    using MakieCore: Theme

    """
        lplot(...)
        lplot!(...)

        Create plots according to the LEGEND style guide for Juleana results
    """
    function lplot end
    function lplot! end
    export lplot, lplot!

   # Define LEGEND colors
    const DeepCove    = "#1A2A5B"
    const AchatBlue   = "#07A9FF"
    const DiamondGrey = "#CCCCCC"

    # Define additional colors
    const ICPCBlue    = "#07A9FF" # AchatBlue
    const PPCPurple   = "#BF00BF"
    const BEGeOrange  = "#FFA500"
    const CoaxGreen   = "#008000"

    # Define LEGEND font
    const LegendFont = "Roboto"

    # Taken from https://docs.makie.org/stable/how-to/match-figure-size-font-sizes-and-dpi
    const inch = 96
    const pt   = 4/3
    const cm   = inch / 2.54

    # Define file path for logo files
    const LegendLogo  = joinpath(@__DIR__, "logo", "legend_darkblue.png")
    const JuleanaLogo = joinpath(@__DIR__, "logo", "juleana.png")

    include("themes.jl")
end
