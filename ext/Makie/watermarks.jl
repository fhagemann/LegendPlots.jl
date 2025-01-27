# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

function add_legend_logo(; fontsize = 12, position = "outer right")

    fig = current_figure()
    ax = current_axis()
    
    # Optimized for 9pt 
    refsize = 9
        
    # modify size using fontsize
    font_scale = fontsize/refsize * 0.016pt
        
    figwidth, figheight = fig.scene.viewport[].widths
    axleft, axbot = ax.scene.viewport[].origin
    axright, axtop = ax.scene.viewport[].origin .+ ax.scene.viewport[].widths

    logo = load(LegendLogo)
    logowidth, logoheight = size(logo) .* font_scale
    legend_suffix = "-200 · " * format("{:02d}-{:04d}", Dates.month(Dates.today()), Dates.year(Dates.today()))

    if position == "outer right"
        img = image!(fig.scene, rot180(logo))
        scale!(img, font_scale, font_scale)
        translate!(img, (axright, axtop - logoheight))

        Makie.text!(fig.scene, legend_suffix, 
            position = ((axright + fontsize / refsize), (axtop - logoheight)), 
            color = DeepCove, fontsize = fontsize, font = :regular, rotation = 270u"°"
        )
    elseif position == "outer top"
        img = image!(fig.scene, rotr90(logo))
        scale!(img, font_scale, font_scale)
        translate!(img, (axleft, axtop))

        Makie.text!(fig.scene, legend_suffix, 
            position = ((axleft + logoheight), (axtop + fontsize / refsize)), 
            color = DeepCove, fontsize = fontsize, font = :regular
        )
    else
        throw(ArgumentError("Position $(position) is invalid. Please choose `outer top` or `outer right`."))
    end
end


function add_juleana_logo(; logo_scale = 0.25, position = :rt)

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
    space = min(0.02 * axwidth, 0.02 * axheight)

    (; halign, valign) = Makie.legend_position_to_aligns(position)
    juleanax = halign == :left   ? axleft + space : axright - juleanawidth - space
    juleanay = valign == :bottom ? axbot  + space : axtop - juleanaheight - space 
    Makie.translate!(img, (juleanax, juleanay))

end

function add_internal_only()

    fig = current_figure()
    ax = current_axis()

    axright, axtop = ax.scene.viewport[].origin .+ ax.scene.viewport[].widths

    Makie.text!(fig.scene, "INTERNAL USE ONLY", font = :bold,
        color = :red, position = (axright, axtop), align = (:right, :bottom))

end