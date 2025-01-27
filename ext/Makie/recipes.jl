# This file is a part of LegendPlots.jl, licensed under the MIT License (MIT).

@recipe(LPlot) do scene
    Attributes(
        xlabel = "Detector",
        ylabel = missing,
        color = AchatBlue,
        legend_logo = true,
        juleana_logo = true,
        approved = false,
        title = ""
    )
end

function Makie.plot!(p::LPlot{<:Tuple{<:NamedTuple{(:par, :f_fit, :x, :y, :gof, :e_unit, :label_y, :label_fit)}}})
    
    report = p[1][]
    title = p.title[]
    
    fig = current_figure()
    ax = current_axis()

    # ax = Axis(fig[1,1],
    #     # xgridvisible = !false,
    #     # ygridvisible = !false,
    #     # xticklabelfont = LegendFont, 
    #     # yticklabelfont = LegendFont,
    #     # xlabelfont = LegendFont,
    #     # ylabelfont = LegendFont,
    #     # xticklabelsize = 0,
    #     # yticklabelsize = 20,
    #     # xticksize = 0,
    #     # xlabelsize = 20,
    #     # ylabelsize = 20,
    #     # titlesize = 24,
    #     # title = title,
    #     # ylabel = report.label_y * " (a.u.)",
    #     # spinewidth = 2,
    #     # xticks = (500:500:2000),
    #     # width = 650,
    #     # height = 270,
    # )
    # ax_res = Axis(fig[2,1],
    #     # xgridvisible = !false,
    #     # ygridvisible = !false,
    #     # xticklabelfont = LegendFont, 
    #     # yticklabelfont = LegendFont,
    #     # xlabelfont = LegendFont,
    #     # ylabelfont = LegendFont,
    #     # xticklabelsize = 20,
    #     # yticklabelsize = 20,
    #     # xlabelsize = 20,
    #     # ylabelsize = 20,
    #     # titlesize = 24,
    #     # xlabel = "E ($(report.e_unit))", 
    #     # ylabel = "Residuals (σ)",
    #     # spinewidth = 2,
    #     # xticks = 500:500:2000,
    #     # yticks = -3:3:3,
    #     # limits = (500,2300, -5, 5)
    # )
    # linkxaxes!(ax, ax_res)
    # rowgap!(fig.layout,0)

    xvalues = report.x
    yvalues = report.y
    res = report.gof.residuals_norm

    ax = Axis(fig[1,1])
    lines!(ax, 0:1:3000, E -> value(report.f_fit(E)), 
        color = (AchatBlue, 0.4), linewidth = 6,
        label = report.label_fit)
    errorbars!(ax, xvalues, value.(yvalues), uncertainty.(yvalues), whiskerwidth = 5, color = DeepCove)
    scatter!(ax, xvalues, value.(yvalues), color = DeepCove, 
        label = "Compton band fits: Gaussian $(report.label_y)(A/E)")

    # axislegend(ax, patchsize = (25, 10), patchlabelgap = 10, framevisible = false, labelsize = 20, 
    #         rowgap = 10, colgap = 20)

    ax2 = Axis(fig[2,1])
    Makie.hspan!(ax2, [-3], [3], color = (AchatBlue, 0.4))
    Makie.scatter!(ax2, xvalues, res, color = DeepCove)

    # go back to first axis
    # p.legend_logo[] && add_legend_logo()

end

function Makie.plot!(p::LPlot{<:Tuple{<:Table, <:PropDict, <:AbstractVector{Symbol}}})
    
    # get info
    chinfo     = p[1][]
    pars       = p[2][]
    properties = p[3][]
    
    # Collect the unit
    u = Unitful.NoUnits
    for det in chinfo.detector
        if haskey(pars, det)
            mval = reduce(getproperty, properties, init = pars[det])
            if !(mval isa MissingProperty)
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
    ylabel = ismissing(p.ylabel[]) ? (length(properties) > 0 ? join(string.(properties), " ") : "Quantity") * ifelse(u == NoUnits, "", " ($u)") : p.ylabel[]

    errorbars!(p, xvalues, ustrip.(u, value.(yvalues)), ustrip.(u, uncertainty.(yvalues)), whiskerwidth = 5, color = p.color)
    scatter!(p, xvalues, ustrip.(u, value.(yvalues)), color = p.color)
    vlines!(p, vlines .- 1, color = :black)

    ax = current_axis()
    ax.xlabel = p.xlabel[]
    ax.ylabel = ylabel
    ax.xticks = (eachindex(labels) .- 1, labels)
    ax.xticklabelrotation = 90u"°"
    ax.limits = ((0, length(labels)), nothing)

    # Add logos if wanted
    p.legend_logo[] && add_legend_logo()
    p.juleana_logo[] && add_juleana_logo()
    !p.approved[] && add_internal_only()

    p
end