# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(ResidualPlot, report) do scene
    Attributes(
        color_1σ = :darkgrey,
        color_3σ = :lightgrey,
        color = :black
    )
end

function Makie.plot!(p::ResidualPlot{<:Tuple{NamedTuple{(:x, :residuals_norm)}}})
    report = p.report[]
    xvalues = report.x
    res = report.residuals_norm
    hspan!(p, [-3], [3], color = p.color_3σ)
    hspan!(p, [-1], [1], color = p.color_1σ)
    scatter!(p, xvalues, res, color = p.color)
    p
end

function Makie.plot!(p::ResidualPlot{<:Tuple{NamedTuple{(:x, :gof)}}})
    report = p.report[]
    xvalues = report.x
    res = report.gof.residuals_norm
    hspan!(p, [-3], [3], color = p.color_3σ)
    hspan!(p, [-1], [1], color = p.color_1σ)
    scatter!(p, xvalues, res, color = p.color)
    p
end

