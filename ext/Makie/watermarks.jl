# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

function LegendPlots.add_legend_logo!(args...; kwargs...)
    LegendPlots.add_logo!(args...; logofile = LegendLogo, textcolor = DeepCove, kwargs...)
end

function LegendPlots.add_juleana_logo!(args...; kwargs...)
    LegendPlots.add_logo!(args...; logofile = JuleanaSimple, textcolor = :black, kwargs...)
end

function LegendPlots.add_logo!(; fontsize = 18, position = "outer right", textcolor = :black, logofile = JuleanaSimple)

    fig = current_figure()
    ax = current_axis()
    
    # Optimized for 13.5pt 
    refsize = 13.5
        
    # modify size using fontsize
    font_scale = fontsize/refsize * 0.024pt
        
    figwidth, figheight = fig.scene.viewport[].widths
    axleft, axbot = ax.scene.viewport[].origin
    axright, axtop = ax.scene.viewport[].origin .+ ax.scene.viewport[].widths

    logo = load(logofile)
    logowidth, logoheight = size(logo) .* font_scale
    legend_suffix = (logofile == LegendLogo ? "-200" : "") * " ⋅ " * 
        format("{:02d}-{:04d}", Dates.month(Dates.today()), Dates.year(Dates.today()))

    if position == "outer right"
        img = image!(fig.scene, rot180(logo))
        scale!(img, font_scale, font_scale)
        translate!(img, (axright, axtop - logoheight))

        Makie.text!(fig.scene, legend_suffix, 
            position = ((axright + fontsize / refsize), (axtop - logoheight)), 
            color = textcolor, fontsize = fontsize, font = :regular, rotation = 270u"°"
        )
    elseif position == "outer top"
        img = image!(fig.scene, rotr90(logo))
        scale!(img, font_scale, font_scale)
        translate!(img, (axleft, axtop))

        Makie.text!(fig.scene, legend_suffix, 
            position = ((axleft + logoheight), (axtop + fontsize / refsize)), 
            color = textcolor, fontsize = fontsize, font = :regular
        )
    else
        throw(ArgumentError("Position $(position) is invalid. Please choose `outer top` or `outer right`."))
    end
end


function LegendPlots.add_preliminary!(args...; kwargs...)
    LegendPlots.add_text!("PRELIMINARY", args...; kwargs...)
end

function LegendPlots.add_internal_use_only!(args...; kwargs...)
    LegendPlots.add_text!("INTERNAL USE ONLY", args...; kwargs...)
end

function LegendPlots.add_text!(text::AbstractString)
    fig = current_figure()
    ax = current_axis()
    axright, axtop = ax.scene.viewport[].origin .+ ax.scene.viewport[].widths
    Makie.text!(fig.scene, text, font = :bold,
        color = :red, position = (axright, axtop), align = (:right, :bottom))
end


function LegendPlots.add_juleana_watermark!(; logo_scale = 0.2, position = :rt)

    fig = current_figure()
    ax = current_axis()

    figwidth, figheight = fig.scene.viewport[].widths
    axleft, axbot = ax.scene.viewport[].origin
    axwidth, axheight = ax.scene.viewport[].widths
    axright, axtop = ax.scene.viewport[].origin .+ ax.scene.viewport[].widths

    juleana = load(JuleanaLogo)
    _logo_scale = logo_scale * axheight / size(juleana,1)
    juleanaheight, juleanawidth = size(juleana) .* _logo_scale
    img = Makie.image!(fig.scene, rotr90(juleana))
    Makie.scale!(img, _logo_scale, _logo_scale)
    space = min(0.03 * axwidth, 0.03 * axheight)

    (; halign, valign) = Makie.legend_position_to_aligns(position)
    juleanax = halign == :left   ? axleft + space : axright - juleanawidth - space
    juleanay = valign == :bottom ? axbot  + space : axtop - juleanaheight - space 
    Makie.translate!(img, (juleanax, juleanay))

end


# function LegendPlots.add_juleana_text!(; fontsize = 12, position = :rb)

#     fig = current_figure()
#     ax = current_axis()

#     figwidth, figheight = fig.scene.viewport[].widths
#     axleft, axbot = ax.scene.viewport[].origin
#     axwidth, axheight = ax.scene.viewport[].widths
#     axright, axtop = ax.scene.viewport[].origin .+ ax.scene.viewport[].widths

#     juleana = load(JuleanaHorizontal)
#     # Value 0.016pt might need to be changed
#     _logo_scale = fontsize/9 * 0.016pt
#     juleanaheight, juleanawidth = size(juleana) .* _logo_scale
#     img = Makie.image!(fig.scene, rot180(juleana))
#     Makie.scale!(img, _logo_scale, _logo_scale)
#     space = 0 #min(0.03 * axwidth, 0.03 * axheight)

#     (; halign, valign) = Makie.legend_position_to_aligns(position)
#     juleanax = halign == :left   ? axleft - juleanaheight : axright
#     juleanay = valign == :bottom ? axbot : axtop - juleanawidth
#     Makie.translate!(img, (juleanax, juleanay))

# end