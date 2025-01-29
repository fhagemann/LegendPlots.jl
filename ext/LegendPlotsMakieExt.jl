# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

module LegendPlotsMakieExt

    using Makie

    using Dates
    using FileIO
    using Format
    using StatsBase
    using Unitful

    using Measurements: value, uncertainty
    using PropDicts: PropDict, MissingProperty
    using TypedTables: Table
    
    using LegendPlots: LegendTheme, LegendFont,
        DeepCove, AchatBlue, DiamondGrey,
        LegendLogo, JuleanaLogo, JuleanaSimple,
        inch, pt, cm

    # extend lplot here
    import LegendPlots
    import LegendPlots: lplot, lplot!, lhist, lhist!, savefig

    function __init__()
        # maybe just use with_theme() in every plot recipe?
        @debug "Updating Makie theme to LEGEND theme"
        update_theme!(LegendTheme)
    end

    function LegendPlots.lplot(args...; figsize = nothing, kwargs...)
        # create new Figure
        fig = Figure(size = figsize)
        LegendPlots.lplot!(args...; kwargs...)
        fig
    end

    function LegendPlots.lhist(args...; kwargs...)
        # create new Figure 
        fig = Figure()
        LegendPlots.lhist!(args...; kwargs...)
        fig
    end

    function LegendPlots.savefig(name::AbstractString; kwargs...)
        fig = current_figure()
        isnothing(fig) && throw(ArgumentError("No figure to save to file."))
        save(name, fig; kwargs...)
    end

    include("Makie/recipes.jl")
end
