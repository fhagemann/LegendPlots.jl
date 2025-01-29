# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(LHistogram, values) do scene
    Attributes(
        label = nothing,
        bins = 15,
        linewidth = 2,
        xlims = nothing,
        ylims = (0,nothing),
    )
end

# Needed for creatings legend using Makie recipes
# https://discourse.julialang.org/t/makie-defining-legend-output-for-a-makie-recipe/121567
function Makie.get_plots(p::LHistogram)
    return p.plots
end

function Makie.plot!(p::LHistogram{<:Tuple{<:AbstractVector}})
    hist!(p, p.values, bins = p.bins)
    stephist!(p, p.values, linewidth = p.linewidth, bins = p.bins, label = p.label)
    p
end