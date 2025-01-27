# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(LPlot, chinfo, pars, properties) do scene
    Theme(
        Axis = (
            xlabel = "Detector"
        )
    )
    Attributes(
        xlabel = "Detector",
        plot_color = AchatBlue,
        legend_logo = true,
        juleana_logo = true,
    )
end

function Makie.plot!(p::LPlot)
    # get info
    chinfo     = p.chinfo[]
    pars       = p.pars[]
    properties = p.properties[]
    
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

    errorbars!(p, xvalues, ustrip.(u, value.(yvalues)), ustrip.(u, uncertainty.(yvalues)), whiskerwidth = 5, color = AchatBlue)
    scatter!(p, xvalues, ustrip.(u, value.(yvalues)), color = AchatBlue)
    vlines!(p, vlines .- 1, color = :black)
    p
end