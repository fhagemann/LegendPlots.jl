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
    
    using LegendPlots: LEGEND_theme, inch, pt, AchatBlue

    # extend lplot here
    import LegendPlots: lplot, lplot!

    function __init__()
        # maybe just use with_theme() in every plot recipe?
        @info "Updating Makie theme to LEGEND theme"
        update_theme!(LEGEND_theme)
    end

    @recipe(MyPlot, chinfo, pars, properties) do scene
        Theme()
    end

    include("Makie/recipes.jl")
end
