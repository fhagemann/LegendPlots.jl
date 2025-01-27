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
        LegendLogo, JuleanaLogo,
        inch, pt, cm

    # extend lplot here
    import LegendPlots: lplot, lplot!

    function __init__()
        # maybe just use with_theme() in every plot recipe?
        @info "Updating Makie theme to LEGEND theme"
        update_theme!(LegendTheme)
    end

    include("Makie/watermarks.jl")
    include("Makie/recipes.jl")
end
