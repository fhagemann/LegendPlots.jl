# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

module LegendPlotsMakieExt

    using Makie

    using Dates
    using FileIO
    using Format
    using Unitful

    using Measurements: value, uncertainty
    using PropDicts: PropDict, MissingProperty
    using TypedTables: Table
    
    using LegendPlots: LegendTheme, LegendFont,
        DeepCove, AchatBlue, DiamondGrey,
        LegendLogo, JuleanaLogo, JuleanaFullLogo,
        inch, pt, cm

    # extend lplot here
    import LegendPlots
    import LegendPlots: lplot, lplot!, residualplot, residualplot!

    function __init__()
        # maybe just use with_theme() in every plot recipe?
        @debug "Updating Makie theme to LEGEND theme"
        update_theme!(LegendTheme)
    end

    function LegendPlots.lplot(args...; kwargs...)
        fig = current_figure()
        LegendPlots.lplot!(fig, args...; kwargs...)
        fig
    end

    include("Makie/recipes.jl")
end
