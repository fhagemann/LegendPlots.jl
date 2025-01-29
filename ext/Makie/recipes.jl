# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

include("aoecorrectionplot.jl")
include("histogram.jl")
include("parameterplot.jl")
include("residualplot.jl")
include("watermarks.jl")


function LegendPlots.lplot!( 
        report::NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}; 
        title::AbstractString = "", show_residuals::Bool = true,
        legend_logo::Bool = false, juleana_logo::Bool = true, 
        preliminary::Bool = true, approved::Bool = false,
        xticks = 500:250:2250, xlims = (500,2300), ylims = nothing,
        legend_position = :rt, juleana_logo_position = :lb,
        col = 1
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
    if legend_logo
        LegendPlots.add_legend_logo!()
    elseif juleana_logo
        LegendPlots.add_juleana_logo!()
    end

    if preliminary
        LegendPlots.add_text!("PRELIMINARY")
    elseif !approved
        LegendPlots.add_text!("INTERNAL USE ONLY")
    end

    fig
end

function LegendPlots.lplot!(
        chinfo::Table, pars::PropDict, properties::AbstractVector{Symbol};
        legend_logo::Bool = false, juleana_logo::Bool = true, 
        preliminary::Bool = true, approved::Bool = false,
        kwargs...
    )

    fig = current_figure()

    # create plot
    ax = Axis(fig[1,1])
    parameterplot!(ax, chinfo, pars, properties; kwargs...)

    # add watermarks
    if legend_logo
        LegendPlots.add_legend_logo!()
    elseif juleana_logo
        LegendPlots.add_juleana_logo!()
    end

    if preliminary
        LegendPlots.add_text!("PRELIMINARY")
    elseif !approved
        LegendPlots.add_text!("INTERNAL USE ONLY")
    end

    fig
end

function LegendPlots.lhist!(
        values::AbstractVector{<:Real};
        legend_logo::Bool = false, juleana_logo::Bool = true,
        preliminary::Bool = true, approved::Bool = false,
        xlabel = "E", ylabel = "Counts", 
        kwargs...
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
    if legend_logo
        LegendPlots.add_legend_logo!()
    elseif juleana_logo
        LegendPlots.add_juleana_logo!()
    end

    if preliminary
        LegendPlots.add_text!("PRELIMINARY")
    elseif !approved
        LegendPlots.add_text!("INTERNAL USE ONLY")
    end

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