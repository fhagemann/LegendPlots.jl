# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

function lplot(chinfo::Table, pars::PropDict, properties::AbstractVector{Symbol}; legend_logo::Bool = true, juleana_logo::Bool = true)

    # Collect the unit
    u = Unitful.NoUnits
    for det in chinfo.detector
        if haskey(pars, det)
            mval = reduce(getproperty, properties, init = pars[det])
            if !(mval isa PropDicts.MissingProperty)
                u = unit(mval)
                break
            end
        end
    end

    # collect the data
    labels = Makie.RichText[]
    labelcolors = Symbol[]
    vlines = Int[]
    xvalues = Int[]
    yvalues = []
    notworking = Int[]
    verbose = true
    for s in sort(unique(chinfo.detstring))
        push!(labels, rich(format("String:{:02d}", s), color = AchatBlue))
        labelcolor = :blue
        push!(vlines, length(labels))
        for det in sort(chinfo[chinfo.detstring .== s], lt = (a,b) -> a.position < b.position).detector
            push!(xvalues, length(labels))
            existing = false
            if haskey(pars, det)
                mval = reduce(getproperty, properties, init = pars[det])
                existing = (mval isa Number && !iszero(value(mval)))
            end
            if existing
                push!(yvalues, uconvert(u, mval))
                push!(labels, rich(string(det), color=:black))
            else
                verbose && @warn "No entry $(join(string.(properties), '/')) for detector $(det)"
                push!(yvalues, NaN * u)
                push!(notworking, length(labels))
                push!(labels, rich(string(det), color=:red))
            end
        
        end
    end
    push!(vlines, length(labels) + 1);
    ylabel = (length(properties) > 0 ? join(string.(properties), " ") : "Quantity") * ifelse(u == NoUnits, "", " ($u)");

    LEGEND_theme = Theme(fontsize = 12, grid = false)
    # set_theme!(LEGEND_theme, internal = true, juleana = true)
    set_theme!(LEGEND_theme)

    fig = Figure(size = (1500,500))
    axmain = Axis(fig,
        bbox = BBox(100,1470,100,500),
        xticklabelfont = LegendFont, 
        yticklabelfont = LegendFont,
        xlabelfont = LegendFont,
        ylabelfont = LegendFont,
        yticklabelsize = 14,
        xlabelsize = 20,
        ylabelsize = 20,
        xlabel = "Detector", ylabel = ylabel, 
        limits = ((0, length(labels)), nothing),
        xticks = (eachindex(labels) .- 1, labels), 
        xticklabelrotation = 90u"°"
    )

    Makie.errorbars!(axmain, xvalues, ustrip.(u, value.(yvalues)), ustrip.(u, uncertainty.(yvalues)), whiskerwidth = 5, color = AchatBlue)
    Makie.scatter!(axmain, xvalues, ustrip.(u, value.(yvalues)), color = AchatBlue)
    Makie.vlines!(axmain, vlines .- 1, color = :black)

    if legend_logo
        ax_legend = Axis(fig,
            bbox = BBox(1475,1500,000, 500),
            backgroundcolor = :transparent,
            leftspinevisible = false,
            rightspinevisible = false,
            bottomspinevisible = false,
            topspinevisible = false,
            xticklabelsvisible = false, 
            yticklabelsvisible = false,
            xgridcolor = :transparent,
            ygridcolor = :transparent,
            xminorticksvisible = false,
            yminorticksvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            xautolimitmargin = (0.0,0.0),
            yautolimitmargin = (0.0,0.0),
            aspect = DataAspect()
        )
        img = load(joinpath(@__DIR__, "logo", "legend_darkblue.png"))
        image!(ax_legend, rot180(hcat(img, fill(Makie.RGBA(0,0,0,0), 500, 8100))))
        legend_suffix = "-200"
        legend_suffix *= " · " * format("{:02d}-{:04d}", Dates.month(Dates.today()), Dates.year(Dates.today()))
        Makie.text!(ax_legend, legend_suffix, position = (0.11,0.83), color = DeepCove, fontsize = 22, font = LegendFont, rotation = 270u"°", space = :relative)   
    end

    if juleana_logo
        ax_juleana = Axis(fig,
            bbox = BBox(1370,1460,400,490),
            backgroundcolor = :transparent,
            leftspinevisible = false,
            rightspinevisible = false,
            bottomspinevisible = false,
            topspinevisible = false,
            xticklabelsvisible = false, 
            yticklabelsvisible = false,
            xgridcolor = :transparent,
            ygridcolor = :transparent,
            xminorticksvisible = false,
            yminorticksvisible = false,
            xticksvisible = false,
            yticksvisible = false,
            xautolimitmargin = (0.0,0.0),
            yautolimitmargin = (0.0,0.0),
            aspect = DataAspect()
        )
        juleana = load(JuleanaLogo)
        image!(ax_juleana, rotr90(juleana))
    end

    current_figure()
end