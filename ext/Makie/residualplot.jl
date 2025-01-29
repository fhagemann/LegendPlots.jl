# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(ResidualPlot, report) do scene
    Attributes(
        color_1σ = :darkgrey,
        color_3σ = :lightgrey,
        color = :black
    )
end

function Makie.plot!(p::ResidualPlot{<:Tuple{NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}}})
    report = p.report[]
    xvalues = report.x
    res = report.gof.residuals_norm
    hspan!(p, [-3], [3], color = p.color_3σ)
    hspan!(p, [-1], [1], color = p.color_1σ)
    scatter!(p, xvalues, res, color = p.color)
    p
end

