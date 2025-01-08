
# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

function lplot(report::NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}; title::AbstractString = "")

    fig = Figure(size = (800,500))
    ax = Axis(fig[1,1],
        bbox = BBox(50,695,50,495),
        xgridvisible = !false,
        ygridvisible = !false,
        xticklabelfont = LEGEND_FONT, 
        yticklabelfont = LEGEND_FONT,
        xlabelfont = LEGEND_FONT,
        ylabelfont = LEGEND_FONT,
        xticklabelsize = 0,
        yticklabelsize = 20,
        xticksize = 0,
        xlabelsize = 20,
        ylabelsize = 20,
        titlesize = 24,
        title = title,
        ylabel = report.label_y * " (a.u.)",
        spinewidth = 2,
        xticks = (500:500:2000),
        width = 650,
        height = 270,
    )
    ax_res = Axis(fig[2,1],
        xgridvisible = !false,
        ygridvisible = !false,
        xticklabelfont = LEGEND_FONT, 
        yticklabelfont = LEGEND_FONT,
        xlabelfont = LEGEND_FONT,
        ylabelfont = LEGEND_FONT,
        xticklabelsize = 20,
        yticklabelsize = 20,
        xlabelsize = 20,
        ylabelsize = 20,
        titlesize = 24,
        xlabel = "E ($(report.e_unit))", 
        ylabel = "Residuals (σ)",
        spinewidth = 2,
        xticks = 500:500:2000,
        yticks = -3:3:3,
        limits = (500,2300, -5, 5)
    )
    linkxaxes!(ax, ax_res)
    rowgap!(fig.layout,0)

    xvalues = report.x
    yvalues = report.y
    res = report.gof.residuals_norm
    Makie.lines!(ax, 0:1:3000, E -> value(report.f_fit(E)), 
        color = (AchatBlue, 0.4), linewidth = 6,
        label = report.label_fit)
    errorbars!(ax, xvalues, value.(yvalues), uncertainty.(yvalues), whiskerwidth = 5, color = DeepCove)
    Makie.scatter!(ax, xvalues, value.(yvalues), color = DeepCove, 
        label = "Compton band fits: Gaussian $(report.label_y)(A/E)")

    axislegend(ax, patchsize = (25, 10), patchlabelgap = 10, framevisible = false, labelsize = 20, 
            rowgap = 10, colgap = 20)

    Makie.hspan!(ax_res, [-3], [3], color = (AchatBlue, 0.4))
    Makie.scatter!(ax_res, xvalues, res, color = DeepCove)
    current_figure()
end