module LegendPlotsMakieExt

    using MakieCore

    # Taken from https://docs.makie.org/stable/how-to/match-figure-size-font-sizes-and-dpi
    const inch = 96
    const pt   = 4/3
    const cm   = inch / 2.54

    const LEGEND_theme = MakieCore.Theme(
        Lines = (
            linewidth   = 10,
            linecap     = :round,
            joinstyle   = :round
        ),
        fonts = (
            bold        = LEGEND_FONT * " Bold",
            bold_italic = LEGEND_FONT * " Bold Italic",
            italic      = LEGEND_FONT * " Italic",
            regular     = LEGEND_FONT * " Regular"
        ),
        palette = (
            color = [ICPCBlue, PPCPurple, BEGeOrange, CoaxGreen],
        ),
        font = :regular,
        fontsize = 9pt,
    )
    export LEGEND_theme

end
