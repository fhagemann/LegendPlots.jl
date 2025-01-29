# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

include("aoecorrectionplot.jl")
include("histogram.jl")
include("parameterplot.jl")
include("residualplot.jl")
include("watermarks.jl")


function LegendPlots.lplot!( 
        report::NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}; 
        title::AbstractString = "", show_residuals::Bool = true,
        xticks = 500:250:2250, xlims = (500,2300), ylims = nothing,
        col = 1, watermark::Bool = false, kwargs...
    )

    fig = current_figure()

    # create plot
    g = GridLayout(fig[1,col])
    ax = Axis(g[1,1], 
        title = title, titlefont = :bold, titlesize = 16pt, 
        xlabel = "E ($(report.e_unit))", ylabel = report.label_y * " (a.u.)", 
        xticks = xticks, limits = (xlims, ylims)
    )
    aoecorrectionplot!(ax, report)
    axislegend(ax, position = legend_position)

    # add residuals
    if !isempty(report.gof) && show_residuals

        ax.xticklabelsize = 0
        ax.xticksize = 0
        ax.xlabel = ""

        ax2 = Axis(g[2,1],
            xlabel = "E ($(report.e_unit))", ylabel = "Residuals (σ)",
            xticks = xticks, yticks = -3:3:3, limits = (xlims,(-5,5))
        )
        residualplot!(ax2, report)

        # link axis and put plots together
        linkxaxes!(ax, ax2)
        rowgap!(g, 0)
        rowsize!(g, 1, Auto(3))

        # align ylabels
        yspace = maximum(tight_yticklabel_spacing!, (ax, ax2))
        ax.yticklabelspace = yspace
        ax2.yticklabelspace = yspace
    end

    all = Axis(g[:,:])
    hidedecorations!(all)
    hidespines!(all)
    current_axis!(all)

    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)

    fig
end

function LegendPlots.lplot!(
        chinfo::Table, pars::PropDict, properties::AbstractVector{Symbol};
        watermark::Bool = false, kwargs...
    )

    fig = current_figure()

    # create plot
    ax = Axis(fig[1,1])
    parameterplot!(ax, chinfo, pars, properties; kwargs...)

    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)

    fig
end

function LegendPlots.lhist!(
        values::AbstractVector{<:Real};
        xlabel = "E", ylabel = "Counts",
        watermark::Bool = false, kwargs...
    )

    fig = current_figure()

    #create plot
    ax = if !isnothing(current_axis())
        current_axis()
    else
        Axis(fig[1,1], 
            xlabel = xlabel, 
            ylabel = ylabel,
            limits = ((1,5), (0,nothing)),
        )
    end
    lhistogram!(ax, values .|> value .|> ustrip; kwargs...)


    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)

    fig
end

function LegendPlots.lhist!(
        values::AbstractVector{<:Quantity};
        xlabel = "E", ylabel = "Counts", 
        kwargs...
    )

    # strip the unit and add it to the xlabel
    u = unit(eltype(values))
    LegendPlots.lhist!(
        ustrip.(u, values);
        xlabel = xlabel * ((u == Unitful.NoUnits) ? "" : " ($(u))"),
        kwargs...
    )
end


function LegendPlots.lhist!(
        h::Histogram{<:Any, 2};
        watermark::Bool = false, kwargs...
    )

    fig = current_figure()

    #create plot
    ax = if !isnothing(current_axis())
        current_axis()
    else
        Axis(fig[1,1],
            titlesize = 15,
            titlegap = 1,
            titlealign = :right,
            # title = get_plottitle(filekey, det, ""; additiional_type=string(aoe_type)),
            # xlabel = "E ($e_unit)",
            # ylabel = rich("A/E", subscript(" norm")),
            # xticks = 0:500:3000,
            # yticks = 0.5:0.5:1.5,
            # limits = (0,2700,0.1,1.8),
        )
    end

    hm = Makie.heatmap!(ax, h.edges..., replace(h.weights, 0 => NaN), colormap = :magma, colorscale = log10)
    cb = Colorbar(fig[1,2], hm, 
        tickformat = values -> rich.("10", superscript.(string.(Int.(log10.(values))))),
        ticks = exp10.(0:ceil(maximum(log10.(h_aoe.weights))))
    )

    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)
end