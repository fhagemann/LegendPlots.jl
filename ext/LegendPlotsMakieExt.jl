module LegendPlotsMakieExt

    using Makie

    using Dates
    using FileIO
    using Format
    using Unitful

    using LegendPlots: LEGEND_theme, inch, pt

    # extend lplot here
    import LegendPlots: lplot

    function __init__()
        # maybe just use with_theme() in every plot recipe?
        @info "Updating Makie theme to LEGEND theme"
        update_theme!(LEGEND_theme)
    end

    @recipe(MyPlot, chinfo, pars, properties) do scene
        Theme(
            Axis = (
                xlabel = "X",
                ylabel = "Y",
                limits = ((0,1), (0,1)),
                aspect = 1,
                xticklabelrotation = 90u"°",
            ),
        )
    end


end
