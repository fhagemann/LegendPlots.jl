# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

include("aoecorrectionplot.jl")
include("parameterplot.jl")
include("residualplot.jl")
include("watermarks.jl")


function LegendPlots.lplot!(fig::Figure, 
        report::NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}; 
        title::AbstractString = "", show_residuals::Bool = true,
        legend_logo::Bool = true, juleana_logo::Bool = true, 
        preliminary::Bool = true, approved::Bool = false,
        xticks = 500:250:2250, xlims = (500,2300), ylims = nothing,
        legend_position = :rt, juleana_logo_position = :lb,
        col = 1
    )

    # create plot
    ax = Axis(fig[1,col], 
    #width = fig.scene.viewport[].widths[1] * 0.8
    )
    aoecorrectionplot!(ax, report)
    ax.title = title
    ax.titlefont = :bold
    ax.titlesize = 12pt
    ax.xlabel = ""
    ax.ylabel = report.label_y * " (a.u.)"
    ax.xticks = xticks
    ax.limits = (xlims, ylims)
    axislegend(ax, position = legend_position, patchsize = (25, 10), patchlabelgap = 10, 
         framevisible = false, labelsize = 12, rowgap = 10, colgap = 20)

    # add residuals
    if !isempty(report.gof) && show_residuals

        ax.xticklabelsize = 0
        ax.xticksize = 0

        ax2 = Axis(fig[2,col])
        residualplot!(ax2, report)
        ax2.xlabel = "E ($(report.e_unit))"
        ax2.ylabel = "Residuals (σ)"
        ax2.xticks = xticks
        ax2.yticks = -3:3:3
        ax2.limits = (xlims,(-5,5))

        # link axis and put plots together
        linkxaxes!(ax, ax2)
        rowgap!(fig.layout, 0)
        rowsize!(fig.layout, 1, Auto(3))

        yspace = maximum(tight_yticklabel_spacing!, (ax, ax2))
        ax.yticklabelspace = yspace
        ax2.yticklabelspace = yspace
    end

    current_axis!(ax)

    # add watermarks
    legend_logo  && add_legend_logo!()
    juleana_logo && add_juleana_logo!(logo_scale = 0.3, position = juleana_logo_position)
    if preliminary
        add_text!("PRELIMINARY")
    elseif !approved
        add_text!("INTERNAL USE ONLY")
    end

    fig
end

function LegendPlots.lplot!( fig::Figure, 
        chinfo::Table, pars::PropDict, properties::AbstractVector{Symbol};
        legend_logo::Bool = true, juleana_logo::Bool = true, 
        preliminary::Bool = true, approved::Bool = false
    )

    # create plot
    ax = Axis(fig[1,1])
    parameterplot!(ax, chinfo, pars, properties)

    # add watermarks
    legend_logo  && add_legend_logo!()
    juleana_logo && add_juleana_logo!()
    if preliminary
        add_text!("PRELIMINARY")
    elseif !approved
        add_text!("INTERNAL USE ONLY")
    end

    fig
end