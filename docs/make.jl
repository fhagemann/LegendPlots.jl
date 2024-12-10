# Use
#
#     DOCUMENTER_DEBUG=true julia --color=yes make.jl local [nonstrict] [fixdoctests]
#
# for local builds.

using Documenter
using LegendPlots

# Doctest setup
DocMeta.setdocmeta!(
    LegendPlots,
    :DocTestSetup,
    :(using LegendPlots);
    recursive=true,
)

makedocs(
    sitename = "LegendPlots",
    modules = [LegendPlots],
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical = "https://fhagemann.github.io/LegendPlots.jl/stable/"
    ),
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
        "LICENSE" => "LICENSE.md",
    ],
    doctest = ("fixdoctests" in ARGS) ? :fix : true,
    linkcheck = !("nonstrict" in ARGS),
    warnonly = ("nonstrict" in ARGS),
)

deploydocs(
    repo = "github.com/fhagemann/LegendPlots.jl.git",
    forcepush = true,
    push_preview = true,
)
