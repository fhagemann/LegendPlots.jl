# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(ResidualPlot, report) do scene
    Attributes(
        color_1σ = :darkgrey,
        color_3σ = :lightgrey,
        color = :black
    )
end

function Makie.default_theme(scene, p::ResidualPlot)
    Theme(
        Axis = (
            xgridvisible = true,
            ygridvisible = true,
            xticklabelfont = :regular, 
            yticklabelfont = :regular,
            xlabelfont = :regular,
            ylabelfont = :regular,
            titlesize = 15,
            xlabel = "E ($(p.report[].e_unit))", 
            ylabel = "Residuals (σ)",
            spinewidth = 2,
            xticks = 500:500:2000,
            yticks = -3:3:3,
            limits = (500,2300,-5,5)
        ),
    )
end


function Makie.plot!(p::ResidualPlot{<:Tuple{NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}}})

    report = p.report[]
    xvalues = report.x
    res = report.gof.residuals_norm

    hspan!(p, [-3], [3], color = p.color_3σ)
    hspan!(p, [-1], [1], color = p.color_1σ)
    hlines!(p, [0], color = :black, linestyle = :dash)
    scatter!(p, xvalues, res, color = p.color)

    p
end

