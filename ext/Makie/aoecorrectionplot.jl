# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(AoECorrectionPlot, report) do scene
    Attributes(
        color = (AchatBlue,0.5),
        markercolor = :black
    )
end

# Needed for creatings legend using Makie recipes
# https://discourse.julialang.org/t/makie-defining-legend-output-for-a-makie-recipe/121567
function Makie.get_plots(p::AoECorrectionPlot)
    return p.plots
end

function Makie.plot!(p::AoECorrectionPlot{<:Tuple{NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}}})
    report = p.report[]
    lines!(p, 0:1:3000, report.f_fit ∘ value, color = p.color, label = report.label_fit)
    errorbars!(p, report.x, value.(report.y), uncertainty.(report.y), color = p.markercolor)
    scatter!(p, report.x, value.(report.y), color = p.markercolor,
        label = "Compton band fits: Gaussian $(report.label_y)(A/E)")
    p
end