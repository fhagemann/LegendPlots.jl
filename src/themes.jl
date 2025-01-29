# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

const LegendTheme = Theme(
    Axis = (
        xlabelfont = :regular,
        ylabelfont = :regular,
        xticklabelfont = :regular, 
        yticklabelfont = :regular,
        xlabelsize = 15pt,
        ylabelsize = 15pt,
        xticklabelsize = 12pt,
        yticklabelsize = 12pt,
        xgridvisible = false,
        ygridvisible = false
    ),
    Scatter = (
        color = :black, # seems to be ignored, defaulting to palette colors
        markersize = 10,
        strokewidth = 0,
    ),
    Errorbars = (
        color = :black, # seems to be ignored, defaulting to palette colors
        whiskerwidth = 6,
    ),
    Lines = (
        linewidth   = 6,
        linecap     = :round,
        joinstyle   = :round
    ),
    Legend = (
        framevisible = false, 
        labelsize = 12pt,
        patchsize = (20, 10), 
        patchlabelgap = 10, 
        rowgap = 10, 
        colgap = 20
    ),
    fonts = (
        bold        = LegendFont * " Bold",
        bold_italic = LegendFont * " Bold Italic",
        italic      = LegendFont * " Italic",
        regular     = LegendFont * " Regular"
    ),
    palette = (
        color = [ICPCBlue, PPCPurple, BEGeOrange, CoaxGreen],
        patchcolor = [(ICPCBlue,0.6), (PPCPurple,0.6), (BEGeOrange,0.6), (CoaxGreen,0.6)],
    ),
    font = :regular,
    fontsize = 12pt,
    figure_padding = 21,
    size = (600,400)
)


"""
    lplot(...)
    lplot!(...)

    Create plots according to the LEGEND style guide for Juleana results
"""
function lplot end
function lplot! end
export lplot, lplot!

function lhist end
function lhist! end
export lhist, lhist!

function add_juleana_logo! end
function add_legend_logo! end
function add_logo! end
function add_preliminary! end
function add_internal_use_only! end
function add_text! end
function add_juleana_watermark! end

