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
        legend_position = :rt, col = 1, watermark::Bool = false, kwargs...
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
    if legend_position != :none 
        axislegend(ax, position = legend_position)
    end

    # add residuals
    if !isempty(report.gof) && show_residuals

        ax.xticklabelsize = 0
        ax.xticksize = 0
        ax.xlabel = ""

        ax2 = Axis(g[2,1],
            xlabel = "E ($(report.e_unit))", ylabel = "Residuals (σ)",
            xticks = xticks, yticks = -3:3:3, limits = (xlims,(-5,5))
        )
        residualplot!(ax2, (x = report.x, residuals_norm = report.gof.residuals_norm))

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
        report::NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)},
        com_report::NamedTuple{(:values, :label_y, :label_fit, :energy)};
        legend_position = :rt, col = 1, kwargs...
    )

    fig = LegendPlots.lplot!(report, legend_position = :none, col = col; kwargs...)

    g = last(contents(fig[1,col]))
    ax = contents(g)[1]
    lines!(ax, com_report.energy, com_report.values, linewidth = 4, color = :red, linestyle = :dash, label = com_report.label_fit)
    axislegend(ax, position = legend_position)

    fig
end


function LegendPlots.lplot!(
    report::NamedTuple{(:v, :h, :f_fit, :f_components, :gof)};
    xlabel = "", ylabel = "Counts / bin",
    title::AbstractString = "", legend_position = :lt,
    xlims = extrema(first(report.h.edges)), ylims = (0.9,maximum(report.h.weights) * 2),
    show_label::Bool = true, show_components::Bool = true, yticks = automatic,
    watermark::Bool = true, show_residuals::Bool = true, col::Int = 1, kwargs...
)

    fig = current_figure()

    # create plot
    g = GridLayout(fig[1,col])
    ax = Axis(g[1,1], 
        title = title, titlefont = :bold, titlesize = 16pt, 
        xlabel = xlabel, ylabel = ylabel, yticks = yticks,
        limits = (xlims, ylims),
        yscale = log10
    )

    hist!(ax, midpoints(first(report.h.edges)), weights = report.h.weights, bins = first(report.h.edges), color = LegendPlots.DiamondGrey, label = "Data")
    lines!(range(xlims..., length = 1000), x -> report.f_fit(x) * step(first(report.h.edges)), color = :black, label = ifelse(show_label, "Best Fit" * (!isempty(report.gof) ? " (p = $(round(report.gof.pvalue, digits=2)))" : ""), ""))

                
    if show_components
        for (idx, component) in enumerate(keys(report.f_components.funcs))
            lines!(
                range(extrema(first(report.h.edges))..., length = 1000), 
                x -> report.f_components.funcs[component](x) * step(first(report.h.edges)), 
                color = report.f_components.colors[component], 
                label = ifelse(show_label, report.f_components.labels[component], ""),
                linestyle = report.f_components.linestyles[component],
                linewidth = 4
            )
        end
    end

    if legend_position != :none 
        axislegend(ax, position = legend_position)
    end

    if !isempty(report.gof) && show_residuals

        ax.xticklabelsize = 0
        ax.xticksize = 0
        ax.xlabel = ""

        ax2 = Axis(g[2,1],
                xlabel = xlabel, ylabel = "Residuals (σ)",
                yticks = -3:3:3, limits = (xlims,(-5,5))
            )
        residualplot!(ax2, (x = midpoints(first(report.h.edges)), residuals_norm = report.gof.residuals_norm))

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
        values::AbstractVector;
        xlabel = "", ylabel = "",
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
    lhistogram!(ax, values .|> value; kwargs...)


    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)

    fig
end

function LegendPlots.lhist!(
        values::AbstractVector{<:Quantity};
        xlabel = "", ylabel = "", 
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

function LegendPlots.lplot!(
        h::Histogram{<:Any, 1};
        watermark::Bool = false, kwargs...
    )

    fig = current_figure()

    #create plot
    ax = if !isnothing(current_axis())
        current_axis()
    else
        Axis(fig[1,1],
            titlesize = 18,
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

    # use built-in method for StatsBase.Histogram, tweak appearance
    Makie.plot!(h; kwargs...)

    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)

    fig
end


function LegendPlots.lhist!(
        h::Histogram{<:Any, 2};
        watermark::Bool = false, rasterize::Bool = false, kwargs...
    )

    fig = current_figure()

    #create plot
    ax = if !isnothing(current_axis())
        current_axis()
    else
        Axis(fig[1,1],
            titlesize = 18,
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

    hm = heatmap!(ax, h.edges..., replace(h.weights, 0 => NaN), colormap = :magma, colorscale = log10)
    hm.rasterize = rasterize
    cb = Colorbar(fig[1,2], hm, 
        tickformat = values -> rich.("10", superscript.(string.(Int.(log10.(values))))),
        ticks = exp10.(0:ceil(maximum(log10.(h.weights))))
    )

    # add watermarks
    watermark && LegendPlots.add_watermarks!(; kwargs...)

    fig
end
