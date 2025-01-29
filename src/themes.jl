# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

const LegendTheme = Theme(
    Axis = (
        xlabelfont = :regular,
        ylabelfont = :regular,
        xticklabelfont = :regular, 
        yticklabelfont = :regular,
        xlabelsize = 12pt,
        ylabelsize = 12pt,
        xticklabelsize = 9pt,
        yticklabelsize = 9pt,
    ),
    Scatter = (
        color = :black, # seems to be ignored, defaulting to palette colors
        markersize = 8,
        strokewidth = 0,
    ),
    Errorbars = (
        color = :black, # seems to be ignored, defaulting to palette colors
        whiskerwidth = 5,
    ),
    Lines = (
        linewidth   = 4,
        linecap     = :round,
        joinstyle   = :round
    ),
    fonts = (
        bold        = LegendFont * " Bold",
        bold_italic = LegendFont * " Bold Italic",
        italic      = LegendFont * " Italic",
        regular     = LegendFont * " Regular"
    ),
    palette = (
        color = [ICPCBlue, PPCPurple, BEGeOrange, CoaxGreen],
    ),
    font = :regular,
    fontsize = 9pt,
)