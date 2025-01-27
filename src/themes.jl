# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

const LEGEND_theme = Theme(
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